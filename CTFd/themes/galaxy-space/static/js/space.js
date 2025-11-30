document.addEventListener('DOMContentLoaded', function () {
    console.log("Enhanced Space.js starting...");
    const canvas = document.createElement('canvas');
    canvas.id = 'space-canvas';
    const ctx = canvas.getContext('2d');
    document.body.appendChild(canvas);

    canvas.style.position = 'fixed';
    canvas.style.top = '0';
    canvas.style.left = '0';
    canvas.style.width = '100vw';
    canvas.style.height = '100vh';
    canvas.style.zIndex = '-1';
    canvas.style.pointerEvents = 'none';

    let width, height;
    let stars = [];
    let shootingStars = [];
    let constellations = [];
    const numStars = 1200;

    // Star color types based on stellar classification
    const starTypes = [
        { color: '#9bb0ff', temp: 'O/B', size: 1.8, brightness: 0.9 },  // Blue-white (hot)
        { color: '#cad7ff', temp: 'A', size: 1.5, brightness: 0.85 },   // White
        { color: '#fff4ea', temp: 'F/G', size: 1.3, brightness: 0.8 },  // Yellow-white (Sun-like)
        { color: '#ffd2a1', temp: 'K', size: 1.1, brightness: 0.7 },    // Orange
        { color: '#ffcc6f', temp: 'M', size: 0.9, brightness: 0.6 }     // Red
    ];

    // Constellation data (simplified positions)
    const constellationData = [
        {
            name: 'Orion',
            stars: [
                [0.3, 0.25], [0.35, 0.3], [0.3, 0.35], [0.25, 0.3], // Belt
                [0.3, 0.2], [0.3, 0.4], [0.35, 0.23], [0.25, 0.37]  // Surrounding
            ]
        },
        {
            name: 'Ursa Major',
            stars: [
                [0.7, 0.3], [0.73, 0.28], [0.76, 0.29], [0.78, 0.27],
                [0.74, 0.32], [0.72, 0.34], [0.7, 0.35]
            ]
        },
        {
            name: 'Cassiopeia',
            stars: [
                [0.5, 0.15], [0.53, 0.13], [0.56, 0.15], [0.59, 0.13], [0.62, 0.15]
            ]
        }
    ];

    function resize() {
        width = window.innerWidth;
        height = window.innerHeight;
        canvas.width = width;
        canvas.height = height;
        initStars();
        initConstellations();
        console.log("Resized to", width, height);
    }

    function initStars() {
        stars = [];
        for (let i = 0; i < numStars; i++) {
            const type = starTypes[Math.floor(Math.random() * starTypes.length)];
            stars.push({
                x: Math.random() * width,
                y: Math.random() * height,
                baseSize: (Math.random() * 0.8 + 0.4) * type.size,
                type: type,
                twinkleOffset: Math.random() * Math.PI * 2,
                twinkleSpeed: 0.001 + Math.random() * 0.002,
                vx: (Math.random() - 0.5) * 0.15,
                vy: (Math.random() - 0.5) * 0.15
            });
        }
    }

    function initConstellations() {
        constellations = constellationData.map(c => ({
            name: c.name,
            stars: c.stars.map(([rx, ry]) => ({
                x: rx * width,
                y: ry * height,
                size: 2,
                brightness: 1
            }))
        }));
    }

    function createShootingStar() {
        const startX = Math.random() * width;
        const startY = Math.random() * height * 0.3; // Upper portion
        const angle = Math.PI / 4 + (Math.random() - 0.5) * Math.PI / 6; // Varied angles
        const speed = 3 + Math.random() * 4;

        shootingStars.push({
            x: startX,
            y: startY,
            vx: Math.cos(angle) * speed,
            vy: Math.sin(angle) * speed,
            trail: [],
            maxTrail: 30,
            life: 1,
            decay: 0.015
        });
    }

    // Create shooting stars at random intervals
    setInterval(() => {
        if (Math.random() < 0.7) { // 30% chance every interval
            createShootingStar();
        }
    }, 5000);

    let mouseX = 0;
    let mouseY = 0;

    document.addEventListener('mousemove', (e) => {
        mouseX = (e.clientX - width / 2) * 0.03;
        mouseY = (e.clientY - height / 2) * 0.03;
    });

    function drawNebula() {
        // Subtle nebula clouds
        const gradient1 = ctx.createRadialGradient(width * 0.3, height * 0.4, 0, width * 0.3, height * 0.4, width * 0.5);
        gradient1.addColorStop(0, 'rgba(138, 43, 226, 0.03)'); // Purple
        gradient1.addColorStop(1, 'transparent');

        const gradient2 = ctx.createRadialGradient(width * 0.7, height * 0.6, 0, width * 0.7, height * 0.6, width * 0.4);
        gradient2.addColorStop(0, 'rgba(72, 61, 139, 0.025)'); // Dark slate blue
        gradient2.addColorStop(1, 'transparent');

        ctx.fillStyle = gradient1;
        ctx.fillRect(0, 0, width, height);
        ctx.fillStyle = gradient2;
        ctx.fillRect(0, 0, width, height);
    }

    function drawConstellations() {
        constellations.forEach(constellation => {
            ctx.strokeStyle = 'rgba(255, 255, 255, 0.15)';
            ctx.lineWidth = 0.5;

            ctx.beginPath();
            constellation.stars.forEach((star, i) => {
                if (i === 0) {
                    ctx.moveTo(star.x, star.y);
                } else {
                    ctx.lineTo(star.x, star.y);
                }

                // Draw constellation stars brighter
                ctx.fillStyle = 'rgba(255, 255, 255, 0.9)';
                ctx.beginPath();
                ctx.arc(star.x, star.y, star.size, 0, Math.PI * 2);
                ctx.fill();
            });
            ctx.stroke();
        });
    }

    function animate() {
        // Clear canvas with subtle fade for trails
        ctx.fillStyle = 'rgba(0, 0, 0, 0.1)';
        ctx.fillRect(0, 0, width, height);

        // Draw nebula
        drawNebula();

        // Draw and update regular stars
        stars.forEach(star => {
            // Subtle drift
            star.x += star.vx + (mouseX * 0.008);
            star.y += star.vy + (mouseY * 0.008);

            // Wrap around
            if (star.x < 0) star.x = width;
            if (star.x > width) star.x = 0;
            if (star.y < 0) star.y = height;
            if (star.y > height) star.y = 0;

            // Twinkling effect
            const twinkle = Math.sin(Date.now() * star.twinkleSpeed + star.twinkleOffset) * 0.3 + 0.7;
            const alpha = star.type.brightness * twinkle;

            // Draw star
            ctx.beginPath();
            ctx.arc(star.x, star.y, star.baseSize, 0, Math.PI * 2);
            ctx.fillStyle = star.type.color.replace(')', `, ${alpha})`).replace('rgb', 'rgba');
            ctx.shadowBlur = star.baseSize * 3;
            ctx.shadowColor = star.type.color;
            ctx.fill();
            ctx.shadowBlur = 0;
        });

        // Draw constellations
        drawConstellations();

        // Draw and update shooting stars
        shootingStars.forEach((ss, index) => {
            ss.x += ss.vx;
            ss.y += ss.vy;
            ss.life -= ss.decay;

            // Add current position to trail
            ss.trail.push({ x: ss.x, y: ss.y, life: ss.life });
            if (ss.trail.length > ss.maxTrail) ss.trail.shift();

            // Draw trail
            ss.trail.forEach((point, i) => {
                const trailAlpha = (i / ss.trail.length) * point.life;
                const size = (i / ss.trail.length) * 2;

                ctx.beginPath();
                ctx.arc(point.x, point.y, size, 0, Math.PI * 2);
                ctx.fillStyle = `rgba(255, 255, 255, ${trailAlpha})`;
                ctx.shadowBlur = 10;
                ctx.shadowColor = `rgba(255, 255, 200, ${trailAlpha})`;
                ctx.fill();
            });

            // Draw head
            ctx.beginPath();
            ctx.arc(ss.x, ss.y, 2.5, 0, Math.PI * 2);
            ctx.fillStyle = `rgba(255, 255, 255, ${ss.life})`;
            ctx.shadowBlur = 15;
            ctx.shadowColor = `rgba(200, 220, 255, ${ss.life})`;
            ctx.fill();
            ctx.shadowBlur = 0;

            // Remove dead shooting stars
            if (ss.life <= 0 || ss.x < 0 || ss.x > width || ss.y > height) {
                shootingStars.splice(index, 1);
            }
        });

        requestAnimationFrame(animate);
    }

    window.addEventListener('resize', resize);
    resize();
    animate();

    // Create initial shooting star
    setTimeout(createShootingStar, 2000);

    console.log("Animation started with", numStars, "stars");
});
