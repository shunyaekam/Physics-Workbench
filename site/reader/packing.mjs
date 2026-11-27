export const exhibits = {
  'sphere-packing': {
    title:'How far apart can 418 points sit?',
    lead:'The closest two points set the spacing for the whole sphere. The new arrangement widens that gap from 10.37028° to 10.37898°. Switch packings to see which pair sets the limit.',
    scope:'These coordinates improve five entries in the November 25, 2026 comparison table. How far the best possible arrangement can go remains open.',
    mount(figure, controls, caption) {
      figure.innerHTML='<canvas id="sphere" data-coordinates="coordinates.json" tabindex="0" aria-label="Sphere with 418 points. Drag or use the arrow keys to rotate."></canvas>';
      controls.innerHTML='<button id="prior" type="button" aria-pressed="false">Previous packing</button><button id="ours" type="button" aria-pressed="true">Our packing</button><button id="center" type="button">Center closest pair</button>';
      caption.innerHTML='<span id="pair">Centers 12 and 26</span> · <output id="angle">10.3789768°</output> apart. The marked pair sets the minimum angle.';
      const script = document.createElement('script');
      script.src = new URL('../sphere.js',import.meta.url);
      document.head.append(script);
    }
  }
};
