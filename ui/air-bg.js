/* 全站粒子背景（浅色版 高性能自律稳态版）：粒子点 + 批处理连线 + 吞噬融合与涨破分裂稳态系统。
 *
 * 用户需求定制：
 * 1. 冲击波光圈不显示（纯净无光圈，但保留点击时物理排斥推开粒子的自然动力学）。
 * 2. 粒子数量提升（更加丰富充盈，但依然基于轻量级批处理，保证完全不卡顿）。
 * 3. 连线上限提高至 7（允许更多连线结构，同时当单点达到或超过 8 根极度密杂时才渐隐疏解）。
 */
(function () {
    var cv = document.getElementById('air-bg') || document.getElementById('bg');
    if (!cv || !cv.getContext) { return; }
    var ctx = cv.getContext('2d');
    var DPR = Math.min(window.devicePixelRatio || 1, 1.25);
    var W = 0, H = 0;

    function resize() {
        W = window.innerWidth; H = window.innerHeight;
        cv.width = W * DPR; cv.height = H * DPR;
        cv.style.width = W + 'px'; cv.style.height = H + 'px';
        ctx.setTransform(DPR, 0, 0, DPR, 0, 0);
    }
    resize();
    window.addEventListener('resize', resize);

    var isDark = document.documentElement.getAttribute('data-theme') === 'dark';
    var COLORS_LIGHT = [
        'rgba(72,118,226,',
        'rgba(124,99,232,',
        'rgba(38,160,190,',
        'rgba(206,96,158,',
        'rgba(230,150,70,'
    ];
    var COLORS_DARK = [
        'rgba(96,165,250,',
        'rgba(167,139,250,',
        'rgba(56,189,248,',
        'rgba(244,114,182,',
        'rgba(251,191,36,'
    ];
    var COLORS = isDark ? COLORS_DARK : COLORS_LIGHT;

    var isTouch = !!(window.matchMedia && window.matchMedia('(hover: none)').matches);
    // 增加粒子密度：桌面端约 130~180，移动端约 70~100
    var TARGET_N = isTouch ? Math.max(65, Math.min(100, Math.round(W * H / 9500)))
                           : Math.max(125, Math.min(185, Math.round(W * H / 6800)));
    var MAX_N = TARGET_N + 25; // 动态硬上限
    var ps = [];

    function createParticle(x, y, alpha, targetAlpha, initR, vx, vy) {
        var baseR = typeof initR === 'number' ? initR : (1.1 + Math.random() * 1.4);
        return {
            x: typeof x === 'number' ? x : Math.random() * W,
            y: typeof y === 'number' ? y : Math.random() * H,
            vx: typeof vx === 'number' ? vx : (Math.random() - 0.5) * 0.28,
            vy: typeof vy === 'number' ? vy : (Math.random() - 0.5) * 0.28,
            r: baseR,
            c: COLORS[(Math.random() * COLORS.length) | 0],
            ph: Math.random() * Math.PI * 2,
            alpha: typeof alpha === 'number' ? alpha : 1.0,
            targetAlpha: typeof targetAlpha === 'number' ? targetAlpha : 1.0,
            bursting: false
        };
    }

    function seed() {
        ps.length = 0;
        for (var i = 0; i < TARGET_N; i++) {
            var r = (Math.random() < 0.12) ? (2.8 + Math.random() * 1.5) : (1.1 + Math.random() * 1.4);
            ps.push(createParticle(undefined, undefined, 1.0, 1.0, r));
        }
    }
    seed();

    var mx = -9999, my = -9999;
    var lastMouseMove = 0;
    var shockwaves = [];

    // 触发纯动力学推开波（无视觉光圈）
    function triggerShockwave(x, y, maxR, dur, isBurst) {
        if (typeof x !== 'number' || typeof y !== 'number') return;
        if (x < -100 || x > W + 100 || y < -100 || y > H + 100) return;
        shockwaves.push({
            x: x,
            y: y,
            t0: performance.now(),
            maxRadius: maxR || 230,
            duration: dur || 550,
            isBurst: !!isBurst
        });
        if (shockwaves.length > 8) {
            shockwaves.shift();
        }
    }

    function onPointerMove(x, y) {
        mx = x; my = y;
        lastMouseMove = performance.now();
    }
    window.addEventListener('mousemove', function (e) { onPointerMove(e.clientX, e.clientY); }, { passive: true });
    window.addEventListener('mouseleave', function () { mx = my = -9999; lastMouseMove = 0; });
    window.addEventListener('pointerdown', function (e) { triggerShockwave(e.clientX, e.clientY, 230, 550, false); }, { passive: true });

    // 内嵌 iframe 里的鼠标与点击转发
    window.addEventListener('message', function (e) {
        var d = e.data;
        if (!d) return;
        if (d.type === 'air-mouse' && typeof d.x === 'number' && typeof d.y === 'number') {
            onPointerMove(d.x, d.y);
        } else if (d.type === 'air-click' && typeof d.x === 'number' && typeof d.y === 'number') {
            triggerShockwave(d.x, d.y, 230, 550, false);
        }
    });

    var boost = 1;
    var LINK2 = 13500, LINK_D = 116, R = 200, R2 = R * R;
    var linkCells = [];
    var pConnections = [];
    var FRAME_MS = 1000 / 30; // 稳定 30fps，极其省 CPU
    var lastFrame = 0;
    var lastDensityCheck = 0;
    var t0 = performance.now();

    window.__airBgBoost = function (k, ms) {
        boost = k || 3;
        setTimeout(function () { boost = 1; }, ms || 900);
    };

    // 预分配用于 3 个透明度阶梯的连线顶点缓冲 (x1, y1, x2, y2)
    var linesBin0 = [];
    var linesBin1 = [];
    var linesBin2 = [];

    function frame(now) {
        if (!running) { return; }
        requestAnimationFrame(frame);
        if (now - lastFrame < FRAME_MS) { return; }
        lastFrame = now;
        var t = (now - t0) / 1000, i, j;
        ctx.clearRect(0, 0, W, H);

        var idleTime = now - lastMouseMove;
        var mouseWeight = 1;
        if (idleTime > 2500) {
            mouseWeight = Math.max(0, 1 - (idleTime - 2500) / 2000);
        }

        // 1. 更新冲击推开波生命周期
        for (i = shockwaves.length - 1; i >= 0; i--) {
            if (now - shockwaves[i].t0 >= shockwaves[i].duration) {
                shockwaves.splice(i, 1);
            }
        }

        // 2. 空间网格
        var CELL = LINK_D, cols = Math.ceil(W / CELL) + 1, rows = Math.ceil(H / CELL) + 1;
        var totalCells = cols * rows;
        while (linkCells.length < totalCells) { linkCells.push([]); }
        for (i = 0; i < totalCells; i++) { linkCells[i].length = 0; }

        if (pConnections.length !== ps.length) {
            pConnections = new Uint8Array(ps.length);
        } else {
            pConnections.fill(0);
        }

        for (i = 0; i < ps.length; i++) {
            var pp = ps[i];
            if (pp.alpha <= 0.05) continue;
            var cx = (pp.x / CELL) | 0, cy = (pp.y / CELL) | 0;
            if (cx >= 0 && cx < cols && cy >= 0 && cy < rows) {
                linkCells[cy * cols + cx].push(i);
            }
        }

        linesBin0.length = 0;
        linesBin1.length = 0;
        linesBin2.length = 0;

        // 3. 邻域作用：连线收集 + 吞噬动力学
        // 需求：连线上限设置为 7
        var MAX_CONN = 7;
        for (i = 0; i < ps.length; i++) {
            var a1 = ps[i];
            if (a1.alpha <= 0.05 || a1.targetAlpha <= 0) continue;
            var gx = (a1.x / CELL) | 0, gy = (a1.y / CELL) | 0;

            var yMin = Math.max(0, gy - 1), yMax = Math.min(rows - 1, gy + 1);
            var xMin = Math.max(0, gx - 1), xMax = Math.min(cols - 1, gx + 1);

            for (var cy2 = yMin; cy2 <= yMax; cy2++) {
                for (var cx2 = xMin; cx2 <= xMax; cx2++) {
                    var bucket = linkCells[cy2 * cols + cx2];
                    for (var bi = 0; bi < bucket.length; bi++) {
                        var k = bucket[bi];
                        if (k <= i) { continue; }
                        var a2 = ps[k];
                        if (a2.alpha <= 0.05 || a2.targetAlpha <= 0) continue;

                        var ex = a2.x - a1.x, ey = a2.y - a1.y;
                        var dist2 = ex * ex + ey * ey;

                        // A. 连线收集（单点连线上限 7）
                        if (dist2 < LINK2) {
                            pConnections[i]++;
                            pConnections[k]++;
                            if (pConnections[i] <= MAX_CONN && pConnections[k] <= MAX_CONN) {
                                var ratio = dist2 / LINK2;
                                if (ratio < 0.33) {
                                    linesBin2.push(a1.x, a1.y, a2.x, a2.y);
                                } else if (ratio < 0.66) {
                                    linesBin1.push(a1.x, a1.y, a2.x, a2.y);
                                } else {
                                    linesBin0.push(a1.x, a1.y, a2.x, a2.y);
                                }
                            }
                        }

                        // B. 吞噬合并（大点吸引并吸收小点）
                        if (dist2 < 3600) { // 约 60px 内引力
                            var big = a1.r >= a2.r ? a1 : a2;
                            var small = a1.r >= a2.r ? a2 : a1;

                            if (big.r > small.r * 1.25 && !big.bursting) {
                                var dist = Math.sqrt(dist2) || 1;
                                var dirX = (big.x - small.x) / dist;
                                var dirY = (big.y - small.y) / dist;

                                // 引力
                                small.vx += dirX * 0.018;
                                small.vy += dirY * 0.018;

                                // 接触吸收
                                if (dist < big.r + small.r + 3.0) {
                                    var transferRate = 0.05;
                                    var massSmall = small.r * small.r;
                                    var massBig = big.r * big.r;

                                    if (massSmall > 0.4) {
                                        massSmall -= transferRate;
                                        massBig += transferRate * 0.85;
                                        small.r = Math.sqrt(Math.max(0.2, massSmall));
                                        big.r = Math.sqrt(massBig);
                                        small.vx = small.vx * 0.7 + big.vx * 0.3;
                                        small.vy = small.vy * 0.7 + big.vy * 0.3;
                                    } else {
                                        small.targetAlpha = 0;
                                        small.alpha = 0;
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // 连线超过 7（即 >= 8）过度密集时平滑淡出，保持画面清透有型
            if (pConnections[i] > MAX_CONN && a1.targetAlpha > 0) {
                a1.targetAlpha = 0;
            }
        }

        // 4. 涨破分裂（Burst）
        var BURST_THRESHOLD = 5.2;
        for (i = 0; i < ps.length; i++) {
            var pb = ps[i];
            if (pb.r >= BURST_THRESHOLD && !pb.bursting && pb.targetAlpha > 0) {
                pb.bursting = true;
                triggerShockwave(pb.x, pb.y, 75, 400, true);

                if (ps.length < MAX_N) {
                    var splitCount = (ps.length < TARGET_N) ? 3 : 2;
                    var angleStep = (Math.PI * 2) / splitCount;
                    var baseAngle = Math.random() * Math.PI * 2;

                    for (var si = 0; si < splitCount; si++) {
                        var ang = baseAngle + si * angleStep;
                        var spd = 0.9 + Math.random() * 0.8;
                        var nvx = Math.cos(ang) * spd + pb.vx * 0.2;
                        var nvy = Math.sin(ang) * spd + pb.vy * 0.2;
                        ps.push(createParticle(
                            pb.x + Math.cos(ang) * (pb.r + 2),
                            pb.y + Math.sin(ang) * (pb.r + 2),
                            0.9, 1.0, 1.1 + Math.random() * 0.6, nvx, nvy
                        ));
                    }
                }

                pb.r = 1.3 + Math.random() * 0.5;
                pb.bursting = false;
                pb.vx = (Math.random() - 0.5) * 0.4;
                pb.vy = (Math.random() - 0.5) * 0.4;
            }
        }

        // 5. 区域粒子密度自平衡（每隔 180ms）
        if (now - lastDensityCheck > 180) {
            lastDensityCheck = now;
            var D_CELL = 240;
            var dCols = Math.ceil(W / D_CELL) || 1;
            var dRows = Math.ceil(H / D_CELL) || 1;
            var dTotal = dCols * dRows;
            var densityCounts = new Uint8Array(dTotal);

            for (i = 0; i < ps.length; i++) {
                var dpi = ps[i];
                if (dpi.targetAlpha <= 0) continue;
                var dcx = Math.max(0, Math.min(dCols - 1, (dpi.x / D_CELL) | 0));
                var dcy = Math.max(0, Math.min(dRows - 1, (dpi.y / D_CELL) | 0));
                densityCounts[dcy * dCols + dcx]++;
            }

            var activeCount = 0;
            for (i = 0; i < ps.length; i++) {
                if (ps[i].targetAlpha > 0) activeCount++;
            }

            // 稀疏区补充
            if (activeCount < TARGET_N && ps.length < MAX_N) {
                var toSpawn = Math.min(4, TARGET_N - activeCount);
                for (var sp = 0; sp < toSpawn; sp++) {
                    var spawnX = Math.random() * W;
                    var spawnY = Math.random() * H;
                    var newR = Math.random() < 0.12 ? (2.8 + Math.random() * 1.4) : (1.1 + Math.random() * 1.3);
                    ps.push(createParticle(spawnX, spawnY, 0, 1.0, newR));
                }
            }
        }

        // 6. 粒子位置与物理更新
        for (i = ps.length - 1; i >= 0; i--) {
            var p = ps[i];

            if (p.alpha < p.targetAlpha) {
                p.alpha = Math.min(p.targetAlpha, p.alpha + 0.10);
            } else if (p.alpha > p.targetAlpha) {
                p.alpha = Math.max(0, p.alpha - 0.12);
            }
            if (p.alpha <= 0 && p.targetAlpha <= 0) {
                ps.splice(i, 1);
                continue;
            }

            var dx = mx - p.x, dy = my - p.y, d2 = dx * dx + dy * dy;
            if (d2 < R2 && mouseWeight > 0.01) {
                var d = Math.sqrt(d2) || 1;
                var near = 1 - d / R;
                if (d < 45) {
                    var rep = (1 - d / 45) * 0.04;
                    p.vx -= (dx / d) * rep;
                    p.vy -= (dy / d) * rep;
                } else {
                    p.vx += (dx / d) * 0.024 * near * mouseWeight;
                    p.vy += (dy / d) * 0.024 * near * mouseWeight;
                }
            }

            // 纯物理冲击波推开动力（无任何光圈图形）
            for (var si = 0; si < shockwaves.length; si++) {
                var swk = shockwaves[si];
                var elapsed = now - swk.t0;
                var progress = elapsed / swk.duration;
                var easeProgress = 1 - Math.pow(1 - progress, 2.5);
                var curRadius = swk.maxRadius * easeProgress;
                var sdx = p.x - swk.x, sdy = p.y - swk.y;
                var sdist = Math.sqrt(sdx * sdx + sdy * sdy) || 1;
                var distFromWave = Math.abs(sdist - curRadius);
                var waveThickness = swk.isBurst ? 30 : 50;

                if (distFromWave < waveThickness) {
                    var wavePower = (1 - distFromWave / waveThickness) * (1 - progress);
                    var force = wavePower * (swk.isBurst ? 0.45 : 0.75);
                    p.vx += (sdx / sdist) * force;
                    p.vy += (sdy / sdist) * force;
                }
            }

            p.vx += Math.sin(t * 0.7 + p.ph) * 0.0022;
            p.vy += Math.cos(t * 0.6 + p.ph) * 0.0022;
            p.x += p.vx * boost; p.y += p.vy * boost;
            p.vx *= 0.965; p.vy *= 0.965;
            if (p.x < -20) { p.x = W + 20; } else if (p.x > W + 20) { p.x = -20; }
            if (p.y < -20) { p.y = H + 20; } else if (p.y > H + 20) { p.y = -20; }
        }

        // 7. 高效连线批量渲染（全屏仅 3 次 stroke）
        isDark = document.documentElement.getAttribute('data-theme') === 'dark';
        ctx.lineWidth = 0.75;
        if (linesBin0.length > 0) {
            ctx.strokeStyle = isDark ? 'rgba(147,197,253,0.09)' : 'rgba(104,134,196,0.08)';
            ctx.beginPath();
            for (j = 0; j < linesBin0.length; j += 4) {
                ctx.moveTo(linesBin0[j], linesBin0[j + 1]);
                ctx.lineTo(linesBin0[j + 2], linesBin0[j + 3]);
            }
            ctx.stroke();
        }
        if (linesBin1.length > 0) {
            ctx.strokeStyle = isDark ? 'rgba(147,197,253,0.18)' : 'rgba(104,134,196,0.18)';
            ctx.beginPath();
            for (j = 0; j < linesBin1.length; j += 4) {
                ctx.moveTo(linesBin1[j], linesBin1[j + 1]);
                ctx.lineTo(linesBin1[j + 2], linesBin1[j + 3]);
            }
            ctx.stroke();
        }
        if (linesBin2.length > 0) {
            ctx.strokeStyle = isDark ? 'rgba(147,197,253,0.32)' : 'rgba(104,134,196,0.30)';
            ctx.beginPath();
            for (j = 0; j < linesBin2.length; j += 4) {
                ctx.moveTo(linesBin2[j], linesBin2[j + 1]);
                ctx.lineTo(linesBin2[j + 2], linesBin2[j + 3]);
            }
            ctx.stroke();
        }

        // 8. 指针牵引线（单次批量绘制）
        if (mx > -9000) {
            ctx.strokeStyle = isDark ? 'rgba(147,197,253,0.25)' : 'rgba(70,110,200,0.22)';
            ctx.lineWidth = 0.8;
            ctx.beginPath();
            var hasPointerLines = false;
            for (i = 0; i < ps.length; i++) {
                var pk = ps[i];
                if (pk.alpha <= 0.05) continue;
                var kx = pk.x - mx, ky = pk.y - my;
                if (kx * kx + ky * ky < 36000) {
                    ctx.moveTo(mx, my);
                    ctx.lineTo(pk.x, pk.y);
                    hasPointerLines = true;
                }
            }
            if (hasPointerLines) { ctx.stroke(); }
        }

        // 9. 粒子绘制（大点光晕，小点清爽）
        for (i = 0; i < ps.length; i++) {
            var pm = ps[i];
            var ddx = mx - pm.x, ddy = my - pm.y, dd2 = ddx * ddx + ddy * ddy;
            var nn = dd2 < R2 ? 1 - Math.sqrt(dd2) / R : 0;
            var finalA = (0.5 + nn * 0.45) * pm.alpha;
            var curR = pm.r * (1 + nn * 0.35);

            if (curR > 3.0 && finalA > 0.1) {
                ctx.fillStyle = pm.c + (finalA * 0.22).toFixed(3) + ')';
                ctx.beginPath();
                ctx.arc(pm.x, pm.y, curR * 1.7, 0, 6.2832);
                ctx.fill();
            }

            ctx.fillStyle = pm.c + finalA.toFixed(3) + ')';
            ctx.beginPath();
            ctx.arc(pm.x, pm.y, curR, 0, 6.2832);
            ctx.fill();
        }

        // 注意：按需求已彻底去除冲击波白光圈的 Canvas 绘制，画面更加纯粹通透
    }
    requestAnimationFrame(frame);

    var running = true;
    document.addEventListener('visibilitychange', function () {
        if (document.hidden) {
            running = false;
        } else if (!running) {
            running = true;
            t0 = performance.now();
            lastFrame = 0;
            requestAnimationFrame(frame);
        }
    });
})();
