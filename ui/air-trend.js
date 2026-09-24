/* Shared 30-sample sparklines & smooth card charts. */
window.AirTrend = {
  valid: value => typeof value === 'number' && Number.isFinite(value),
  node(tag, attrs) {
    const n = document.createElementNS('http://www.w3.org/2000/svg', tag);
    for (const [k, v] of Object.entries(attrs)) n.setAttribute(k, String(v));
    return n;
  },
  getCurvePath(pts, k = 0.18, clampMaxY = null, clampMinY = null) {
    if (!pts || !pts.length) return '';
    if (pts.length === 1) return `M ${pts[0].x.toFixed(1)},${pts[0].y.toFixed(1)}`;
    if (pts.length === 2) return `M ${pts[0].x.toFixed(1)},${pts[0].y.toFixed(1)} L ${pts[1].x.toFixed(1)},${pts[1].y.toFixed(1)}`;

    let d = `M ${pts[0].x.toFixed(1)},${pts[0].y.toFixed(1)}`;
    for (let i = 0; i < pts.length - 1; i++) {
      const p0 = pts[Math.max(0, i - 1)];
      const p1 = pts[i];
      const p2 = pts[i + 1];
      const p3 = pts[Math.min(pts.length - 1, i + 2)];

      let cp1x = p1.x + (p2.x - p0.x) * k;
      let cp1y = p1.y + (p2.y - p0.y) * k;
      let cp2x = p2.x - (p3.x - p1.x) * k;
      let cp2y = p2.y - (p3.y - p1.y) * k;

      if (clampMaxY !== null) {
        cp1y = Math.min(clampMaxY, cp1y);
        cp2y = Math.min(clampMaxY, cp2y);
      }
      if (clampMinY !== null) {
        cp1y = Math.max(clampMinY, cp1y);
        cp2y = Math.max(clampMinY, cp2y);
      }

      d += ` C ${cp1x.toFixed(1)},${cp1y.toFixed(1)} ${cp2x.toFixed(1)},${cp2y.toFixed(1)} ${p2.x.toFixed(1)},${p2.y.toFixed(1)}`;
    }
    return d;
  },
  draw(svg, samples, read, { color = '#2563eb', span = 4, identity = () => '', fixedMin, fixedMax, unit = '', showArea = false, gradId = '', h = 44, showGrid = false, minBound, maxBound } = {}) {
    svg._trendData = { samples, read, opts: { color, span, identity, fixedMin, fixedMax, unit, showArea, gradId, h, showGrid, minBound, maxBound } };
    svg.replaceChildren();
    samples = samples.slice(-30);
    const values = samples.map(read), valid = values.filter(this.valid);
    if (!valid.length) return;

    // Responsive viewBox width: 1 SVG unit = 1 pixel -> 100% round circles on PC & mobile
    const w = Math.max(160, Math.round(svg.clientWidth)) || 300;
    svg.setAttribute('viewBox', `0 0 ${w} ${h}`);
    svg.removeAttribute('preserveAspectRatio');

    let low, high, clampMaxY, clampMinY, leftPad = 6, rightPad = 6, bottomY = h - 6, topY = 6;
    const isFixed = (fixedMin !== undefined && fixedMax !== undefined);
    const hasGrid = Boolean(showGrid || isFixed);

    if (hasGrid) {
      leftPad = 36;
      rightPad = 8;
      bottomY = h - 8;
      topY = 8;
      clampMaxY = bottomY;
      clampMinY = topY;

      if (isFixed) {
        low = fixedMin;
        high = fixedMax;
      } else {
        const minVal = Math.min(...valid), maxVal = Math.max(...valid);
        const range = maxVal - minVal;
        const pad = Math.max(0.6, range * 0.15);
        low = minBound !== undefined ? Math.max(minBound, Math.floor(minVal - pad)) : Math.floor(minVal - pad);
        high = maxBound !== undefined ? Math.min(maxBound, Math.ceil(maxVal + pad)) : Math.ceil(maxVal + pad);
        const minSpan = span || 6;
        if (high - low < minSpan) {
          const diff = minSpan - (high - low);
          const addHigh = Math.ceil(diff / 2);
          const subLow = Math.floor(diff / 2);
          if (maxBound !== undefined && high + addHigh > maxBound) {
            high = maxBound;
            low = Math.max(minBound !== undefined ? minBound : -Infinity, high - minSpan);
          } else if (minBound !== undefined && low - subLow < minBound) {
            low = minBound;
            high = Math.min(maxBound !== undefined ? maxBound : Infinity, low + minSpan);
          } else {
            high += addHigh;
            low -= subLow;
          }
        }
      }

      if (showArea && gradId) {
        const defs = this.node('defs', {});
        defs.innerHTML = `<linearGradient id="${gradId}" x1="0" y1="0" x2="0" y2="1"><stop offset="0%" stop-color="${color}" stop-opacity="0.18"/><stop offset="100%" stop-color="${color}" stop-opacity="0.01"/></linearGradient>`;
        svg.append(defs);
      }

      const midY = (topY + bottomY) / 2;
      const fmt = v => Math.round(v) + (unit || '');
      const ticks = [
        { y: topY, val: fmt(high) },
        { y: midY, val: fmt((high + low) / 2) },
        { y: bottomY, val: fmt(low) }
      ];
      ticks.forEach((t, idx) => {
        const grid = this.node('line', {
          x1: leftPad, x2: w - rightPad, y1: t.y, y2: t.y,
          stroke: idx === 2 ? '#e2e8f0' : '#f1f5f9',
          'stroke-width': 1,
          'stroke-dasharray': idx === 2 ? 'none' : '3 3'
        });
        const lbl = this.node('text', {
          x: leftPad - 5, y: t.y + 3.5,
          'text-anchor': 'end',
          'font-size': '10',
          fill: '#94a3b8',
          'font-family': 'ui-monospace, monospace'
        });
        lbl.textContent = t.val;
        svg.append(grid, lbl);
      });
    } else {
      const min = Math.min(...valid), max = Math.max(...valid), range = Math.max(span, max - min),
            center = (max + min) / 2;
      low = center - range / 2 - range * 0.12;
      high = center + range / 2 + range * 0.12;
      clampMaxY = bottomY;
      clampMinY = topY;
    }

    const getY = v => bottomY - (Math.max(low, Math.min(high, v)) - low) / (high - low) * (bottomY - topY);

    let segmentPts = [], last = null;
    const flush = () => {
      if (segmentPts.length > 1) {
        const curveD = this.getCurvePath(segmentPts, 0.18, clampMaxY, clampMinY);
        if (showArea && gradId) {
          const areaD = `${curveD} L ${segmentPts[segmentPts.length - 1].x.toFixed(1)},${bottomY} L ${segmentPts[0].x.toFixed(1)},${bottomY} Z`;
          svg.append(this.node('path', {
            d: areaD,
            fill: `url(#${gradId})`,
            'pointer-events': 'none',
            'class': 'trend-area'
          }));
        }
        svg.append(this.node('path', {
          d: curveD,
          fill: 'none',
          stroke: color,
          'stroke-width': 1.8,
          'stroke-linecap': 'round',
          'stroke-linejoin': 'round',
          'vector-effect': 'non-scaling-stroke',
          'class': 'trend-line'
        }));
      }
      segmentPts = [];
    };

    let lastValidIdx = -1;
    for (let k = values.length - 1; k >= 0; k--) {
      if (this.valid(values[k])) {
        lastValidIdx = k;
        break;
      }
    }

    const pts = [];
    const plotWidth = w - leftPad - rightPad;
    samples.forEach((s, i) => {
      const v = values[i];
      if (!this.valid(v)) {
        flush();
        last = null;
        return;
      }
      // Break line if gap > 12.5s (allows for 5s sampling interval)
      if (last && (identity(last) !== identity(s) || Date.parse(s.at) - Date.parse(last.at) > 12500 || Date.parse(s.at) < Date.parse(last.at))) {
        flush();
      }
      const x = leftPad + (30 - samples.length + i) / 29 * plotWidth;
      const y = getY(v);
      const pt = { x, y, sample: s, val: v, isLatest: (i === lastValidIdx) };
      segmentPts.push(pt);
      pts.push(pt);

      // Clean circular dot (guaranteed 1:1 roundness, perfectly circular)
      const dot = this.node('circle', {
        cx: x.toFixed(1),
        cy: y.toFixed(1),
        r: pt.isLatest ? (hasGrid ? 3.5 : 3) : (hasGrid ? 2.5 : 2),
        fill: color,
        stroke: pt.isLatest ? '#ffffff' : 'none',
        'stroke-width': pt.isLatest ? 1.5 : 0,
        'class': pt.isLatest ? 'trend-dot trend-dot-live' : 'trend-dot'
      });
      svg.append(dot);
      last = s;
    });
    flush();

    // Active hover circle (in SVG)
    const activeDot = this.node('circle', {
      cx: 0, cy: 0, r: 4.5,
      fill: color,
      stroke: '#ffffff',
      'stroke-width': 2,
      style: 'display:none;pointer-events:none;filter:drop-shadow(0 0 4px ' + color + ');'
    });
    svg.append(activeDot);

    // Full-area hit target (rect in SVG)
    const hitRect = this.node('rect', {
      x: 0, y: 0, width: w, height: h,
      fill: 'transparent',
      'pointer-events': 'all',
      style: 'cursor:crosshair;'
    });
    svg.append(hitRect);

    // HTML Guideline & Popover in parent container
    const svgWrap = svg.parentElement;
    const guide = svgWrap?.querySelector('.trend-guide-line');
    const popover = svgWrap?.querySelector('.trend-popover');
    const label = svg.dataset.label || '';

    const updateHover = (clientX) => {
      if (!pts.length) return;
      const rect = svg.getBoundingClientRect();
      const relX = Math.max(0, Math.min(1, (clientX - rect.left) / rect.width));
      const targetSvgX = relX * w;

      let closest = pts[0], minDist = Infinity;
      for (const p of pts) {
        const d = Math.abs(p.x - targetSvgX);
        if (d < minDist) {
          minDist = d;
          closest = p;
        }
      }

      activeDot.setAttribute('cx', closest.x.toFixed(1));
      activeDot.setAttribute('cy', closest.y.toFixed(1));
      activeDot.style.display = '';

      const pixelLeft = (closest.x / w) * rect.width;

      if (guide) {
        guide.style.left = `${pixelLeft}px`;
        guide.style.display = 'block';
      }

      if (popover) {
        const timeStr = new Date(closest.sample.at).toLocaleTimeString();
        const formattedVal = closest.val.toFixed(1) + (unit ? unit : '');
        popover.innerHTML = `<span class="pop-time">${timeStr}</span><span class="pop-val">${label ? label + ': ' : ''}<strong>${formattedVal}</strong></span>`;
        popover.style.display = 'block';
        popover.style.left = `${pixelLeft}px`;
      }
    };

    const clearHover = () => {
      activeDot.style.display = 'none';
      if (guide) guide.style.display = 'none';
      if (popover) popover.style.display = 'none';
    };

    hitRect.onpointermove = (e) => updateHover(e.clientX);
    hitRect.onpointerdown = (e) => updateHover(e.clientX);
    hitRect.onpointerleave = clearHover;
    hitRect.ontouchstart = (e) => {
      if (e.touches.length) updateHover(e.touches[0].clientX);
    };
    hitRect.ontouchmove = (e) => {
      if (e.touches.length) updateHover(e.touches[0].clientX);
    };
  },
  row(label, color) {
    const row = document.createElement('div');
    row.className = 'trend-row';
    const name = document.createElement('span');
    name.className = 'trend-name';
    name.textContent = label;

    const svgWrap = document.createElement('div');
    svgWrap.className = 'trend-svg-wrap';

    const svg = this.node('svg', {
      viewBox: '0 0 300 44',
      role: 'img',
      'aria-label': label + '趋势'
    });
    svg.dataset.label = label;

    const guide = document.createElement('div');
    guide.className = 'trend-guide-line';

    const popover = document.createElement('div');
    popover.className = 'trend-popover';
    svgWrap.append(svg, guide, popover);

    const value = document.createElement('strong');
    value.className = 'trend-value';
    value.textContent = '—';

    row.append(name, svgWrap, value);
    if (color) row.style.setProperty('--trend-color', color);

    if (window.ResizeObserver) {
      const ro = new ResizeObserver(() => {
        if (svg._trendData && svg.clientWidth > 0) {
          AirTrend.draw(svg, svg._trendData.samples, svg._trendData.read, svg._trendData.opts);
        }
      });
      ro.observe(svgWrap);
    }

    return { row, svg, value, popover, guide };
  },
  cardChart(container, { label = '', color = '#2563eb', unit = '%', gradId = '' } = {}) {
    const wrap = document.createElement('div');
    wrap.className = 'card-trend-wrap';

    const svg = this.node('svg', {
      viewBox: '0 0 340 68',
      role: 'img',
      'aria-label': label + '趋势'
    });
    svg.dataset.label = label;

    const guide = document.createElement('div');
    guide.className = 'trend-guide-line';

    const popover = document.createElement('div');
    popover.className = 'trend-popover';
    wrap.append(svg, guide, popover);
    container.replaceChildren(wrap);

    const effectiveGradId = gradId || ('grad_' + Math.random().toString(36).slice(2, 7));

    if (window.ResizeObserver) {
      const ro = new ResizeObserver(() => {
        if (svg._trendData && svg.clientWidth > 0) {
          AirTrend.draw(svg, svg._trendData.samples, svg._trendData.read, svg._trendData.opts);
        }
      });
      ro.observe(wrap);
    }

    return {
      update(samples, read) {
        AirTrend.draw(svg, samples, read, {
          color,
          unit,
          showArea: true,
          showGrid: true,
          gradId: effectiveGradId,
          h: 68,
          span: 6,
          minBound: 0,
          maxBound: 100
        });
      },
      svg, wrap, popover, guide
    };
  }
};
