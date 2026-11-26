import tempfile
import unittest
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

from ops.hosted import HourlyLimit, reserve


class HostedQuotaTest(unittest.TestCase):
    def test_one_concurrent_start_and_rolling_hour(self):
        with tempfile.TemporaryDirectory() as directory:
            service = Path(directory)

            def start(_):
                try:
                    reserve(service, 10000)
                except HourlyLimit:
                    return False
                return True

            with ThreadPoolExecutor(4) as pool:
                self.assertEqual(sum(pool.map(start, range(8))), 1)
            with self.assertRaises(HourlyLimit):
                reserve(service, 13599.99)
            reserve(service, 13600)
            with self.assertRaises(HourlyLimit):
                reserve(service, 9999)
