document.addEventListener('DOMContentLoaded', () => {
    console.log("Neutron Star theme initializing...");
    const canvas = document.createElement('canvas');
    canvas.style.position = 'fixed';
    canvas.style.top = '0';
    canvas.style.left = '0';
    canvas.style.width = '100vw';
    canvas.style.height = '100vh';
    canvas.style.zIndex = '-1';
    canvas.style.pointerEvents = 'none';
    canvas.style.background = '#000000'; // Ensure background is black
    document.body.appendChild(canvas);

    const ctx = canvas.getContext('2d');
    let width, height;

    function resize() {
        width = window.innerWidth;
        height = window.innerHeight;
        canvas.width = width;
        canvas.height = height;
        console.log("Canvas resized to:", width, height);
    }
    window.addEventListener('resize', resize);
    resize();

    // Neutron Star properties
    const neutronStar = {
        angle: 0,
        color: '#add8e6', // Light blueish
        glowColor: '#00ffff'
    };

    // Stars
    const stars = [];
    const numStars = 50; // Very few stars

    for (let i = 0; i < numStars; i++) {
        stars.push({
            x: Math.random() * width,
            y: Math.random() * height,
            size: Math.random() * 1.5,
            opacity: Math.random()
        });
    }

    function drawNeutronStar() {
        // Position in bottom right, but visible
        const x = width * 0.85;
        const y = height * 0.85;
        const radius = 40;

        ctx.save();
        ctx.translate(x, y);
        ctx.rotate(neutronStar.angle);

        // Jets
        const jetLength = 800;
        const jetWidth = 4;

        // Jet 1
        const gradient1 = ctx.createLinearGradient(0, 0, 0, -jetLength);
        gradient1.addColorStop(0, 'rgba(200, 240, 255, 0.8)');
        gradient1.addColorStop(0.1, 'rgba(100, 200, 255, 0.4)');
        gradient1.addColorStop(1, 'rgba(0, 0, 0, 0)');

        ctx.beginPath();
        ctx.moveTo(-jetWidth, 0);
        ctx.lineTo(jetWidth, 0);
        ctx.lineTo(jetWidth * 4, -jetLength); // Fanning out slightly
        ctx.lineTo(-jetWidth * 4, -jetLength);
        ctx.fillStyle = gradient1;
        ctx.fill();

        // Jet 2
        const gradient2 = ctx.createLinearGradient(0, 0, 0, jetLength);
        gradient2.addColorStop(0, 'rgba(200, 240, 255, 0.8)');
        gradient2.addColorStop(0.1, 'rgba(100, 200, 255, 0.4)');
        gradient2.addColorStop(1, 'rgba(0, 0, 0, 0)');

        ctx.beginPath();
        ctx.moveTo(-jetWidth, 0);
        ctx.lineTo(jetWidth, 0);
        ctx.lineTo(jetWidth * 4, jetLength);
        ctx.lineTo(-jetWidth * 4, jetLength);
        ctx.fillStyle = gradient2;
        ctx.fill();

        // Star Body
        ctx.beginPath();
        ctx.arc(0, 0, radius, 0, Math.PI * 2);
        ctx.fillStyle = neutronStar.color;
        ctx.shadowBlur = 50;
        ctx.shadowColor = neutronStar.glowColor;
        ctx.fill();

        // Accretion Disk (simplified)
        // We draw this *after* the body to make it look like it surrounds it, 
        // but for a simple 2D effect, drawing it on top or behind depends on the look.
        // Let's draw it on top but with transparency.
        ctx.beginPath();
        ctx.ellipse(0, 0, radius * 2.5, radius * 0.4, Math.PI / 4, 0, Math.PI * 2);
        ctx.strokeStyle = 'rgba(255, 100, 50, 0.5)';
        ctx.lineWidth = 3;
        ctx.stroke();

        ctx.restore();

        // Rotate very slowly
        neutronStar.angle += 0.005;
    }

    function drawStars() {
        ctx.fillStyle = '#ffffff';
        stars.forEach(star => {
            // Twinkle
            if (Math.random() < 0.01) star.opacity = Math.random();

            ctx.globalAlpha = star.opacity;
            ctx.beginPath();
            ctx.arc(star.x, star.y, star.size, 0, Math.PI * 2);
            ctx.fill();
        });
        ctx.globalAlpha = 1;
    }

    function animate() {
        ctx.clearRect(0, 0, width, height);

        // Fill background manually to be sure
        ctx.fillStyle = '#000000';
        ctx.fillRect(0, 0, width, height);

        drawStars();
        drawNeutronStar();

        requestAnimationFrame(animate);
    }

    animate();
    console.log("Neutron Star animation loop started");
});
