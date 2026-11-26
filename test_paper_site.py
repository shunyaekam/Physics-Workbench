"""Every published PDF should have a web edition in the shared research-map reader."""
from html.parser import HTMLParser
from pathlib import Path
import unittest


ROOT = Path(__file__).resolve().parent


class PaperLinks(HTMLParser):
    def __init__(self):
        super().__init__()
        self.in_header = False
        self.reader_links = []
        self.paper_links = []

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        if tag == "header":
            self.in_header = "reader-head" in attrs.get("class", "").split()
        elif tag == "a" and "href" in attrs:
            if self.in_header:
                self.reader_links.append(attrs["href"])
            if attrs["href"].startswith("papers/"):
                self.paper_links.append(attrs["href"])

    def handle_endtag(self, tag):
        if tag == "header":
            self.in_header = False


class PublishedPaperTests(unittest.TestCase):
    def test_each_paper_has_reader_navigation_to_its_pdf_and_the_map(self):
        papers = ROOT / "papers"
        for pdf in sorted(papers.rglob("*.pdf")):
            with self.subTest(paper=pdf.stem):
                reader = papers / pdf.stem / "index.html"
                header = PaperLinks()
                header.feed(reader.read_text())
                destinations = {(reader.parent / href).resolve() for href in header.reader_links}
                self.assertIn(pdf, destinations)
                self.assertIn(ROOT / "catalogue.html", destinations)

    def test_map_links_directly_to_every_published_reader(self):
        index = PaperLinks()
        index.feed((ROOT / "catalogue.html").read_text())
        linked = {(ROOT / href).resolve() for href in index.paper_links}
        for pdf in (ROOT / "papers").rglob("*.pdf"):
            with self.subTest(paper=pdf.stem):
                self.assertIn(ROOT / "papers" / pdf.stem, linked)
