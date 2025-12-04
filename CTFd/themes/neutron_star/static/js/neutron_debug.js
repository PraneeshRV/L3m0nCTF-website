document.addEventListener('DOMContentLoaded', () => {
    alert("Neutron Star Debug Script Loaded!"); // Immediate visual confirmation
    console.log("Neutron Star DEBUG script initializing...");

    const canvas = document.createElement('canvas');
    canvas.style.position = 'fixed';
    canvas.style.top = '0';
    canvas.style.left = '0';
    canvas.style.width = '100vw';
    canvas.style.height = '100vh';
    canvas.style.zIndex = '999999'; // Force on top of everything
    canvas.style.pointerEvents = 'none'; // Click through
    canvas.style.background = 'red'; // Bright red
    document.body.appendChild(canvas);

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

    function animate() {
        ctx.clearRect(0, 0, width, height);

        // Draw a big blue circle
        ctx.beginPath();
        ctx.arc(width / 2, height / 2, 100, 0, Math.PI * 2);
        ctx.fillStyle = 'blue';
        ctx.fill();

        requestAnimationFrame(animate);
    }

    animate();
});
