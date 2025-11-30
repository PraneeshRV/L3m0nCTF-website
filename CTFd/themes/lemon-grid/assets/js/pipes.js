
document.addEventListener('DOMContentLoaded', () => {
    const canvas = document.getElementById('pipes-canvas');
    if (!canvas) return;

    const ctx = canvas.getContext('2d');
    let width, height;

    function resize() {
        width = window.innerWidth;
        height = window.innerHeight;
        canvas.width = width;
        canvas.height = height;
    }

    window.addEventListener('resize', resize);
    resize();

    let offset = 0;
    const speed = 1;
    const gridSize = 40;

    function draw() {
        ctx.fillStyle = '#0a0a0a';
        ctx.fillRect(0, 0, width, height);

        ctx.strokeStyle = '#DFFF00';
        ctx.lineWidth = 1;
        ctx.shadowBlur = 5;
        ctx.shadowColor = '#DFFF00';

        // Vertical lines
        for (let x = 0; x <= width; x += gridSize) {
            ctx.beginPath();
            ctx.moveTo(x, 0);
            ctx.lineTo(x, height);
            ctx.stroke();
        }

        // Horizontal lines (moving down)
        for (let y = offset; y <= height; y += gridSize) {
            ctx.beginPath();
            ctx.moveTo(0, y);
            ctx.lineTo(width, y);
            ctx.stroke();
        }

        offset = (offset + speed) % gridSize;

        // Perspective effect (simple)
        // To make it look 3D, we could transform the context, but let's keep it simple retro grid for now.
        // Or we can add a gradient overlay to fade it out at the top.
        const gradient = ctx.createLinearGradient(0, 0, 0, height);
        gradient.addColorStop(0, 'rgba(10, 10, 10, 1)');
        gradient.addColorStop(0.5, 'rgba(10, 10, 10, 0)');
        ctx.fillStyle = gradient;
        ctx.fillRect(0, 0, width, height);

        requestAnimationFrame(draw);
    }

    draw();
});
