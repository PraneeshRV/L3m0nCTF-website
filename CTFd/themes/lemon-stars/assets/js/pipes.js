
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

    const stars = [];
    const starCount = 200;

    class Star {
        constructor() {
            this.reset();
        }

        reset() {
            this.x = Math.random() * width;
            this.y = Math.random() * height;
            this.z = Math.random() * 2 + 0.5; // Depth/Speed
            this.size = Math.random() * 1.5;
            this.opacity = Math.random();
        }

        update() {
            this.y += this.z * 0.5; // Move down
            if (this.y > height) {
                this.y = 0;
                this.x = Math.random() * width;
            }
        }

        draw() {
            ctx.beginPath();
            ctx.fillStyle = `rgba(223, 255, 0, ${this.opacity})`; // Lemon color
            ctx.arc(this.x, this.y, this.size, 0, Math.PI * 2);
            ctx.fill();
        }
    }

    for (let i = 0; i < starCount; i++) {
        stars.push(new Star());
    }

    function animate() {
        ctx.clearRect(0, 0, width, height);

        // Draw galaxy/nebula background (subtle)
        const gradient = ctx.createRadialGradient(width / 2, height / 2, 0, width / 2, height / 2, width);
        gradient.addColorStop(0, 'rgba(20, 20, 20, 1)');
        gradient.addColorStop(1, 'rgba(0, 0, 0, 1)');
        ctx.fillStyle = gradient;
        ctx.fillRect(0, 0, width, height);

        stars.forEach(star => {
            star.update();
            star.draw();
        });

        requestAnimationFrame(animate);
    }

    animate();
});
