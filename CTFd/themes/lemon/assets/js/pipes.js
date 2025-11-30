
document.addEventListener('DOMContentLoaded', () => {
    const canvas = document.getElementById('pipes-canvas');
    if (!canvas) return;

    const ctx = canvas.getContext('2d');
    let width, height;
    let pipes = [];
    const pipeCount = 20;
    const pipeSpeed = 2;
    const colors = ['#DFFF00', '#CCFF00', '#FFFF00']; // Lemon neon shades

    function resize() {
        width = window.innerWidth;
        height = window.innerHeight;
        canvas.width = width;
        canvas.height = height;
    }

    window.addEventListener('resize', resize);
    resize();

    class Pipe {
        constructor() {
            this.reset();
        }

        reset() {
            this.x = Math.random() * width;
            this.y = Math.random() * height;
            this.direction = Math.floor(Math.random() * 4); // 0: up, 1: right, 2: down, 3: left
            this.color = colors[Math.floor(Math.random() * colors.length)];
            this.history = [];
            this.maxLength = 50 + Math.random() * 100;
            this.life = 0;
            this.width = 2 + Math.random() * 3;
        }

        update() {
            this.life++;
            if (this.life > this.maxLength) {
                this.reset();
                return;
            }

            this.history.push({ x: this.x, y: this.y });
            if (this.history.length > this.maxLength) {
                this.history.shift();
            }

            // Move
            switch (this.direction) {
                case 0: this.y -= pipeSpeed; break;
                case 1: this.x += pipeSpeed; break;
                case 2: this.y += pipeSpeed; break;
                case 3: this.x -= pipeSpeed; break;
            }

            // Random turn
            if (Math.random() < 0.02) {
                this.direction = (this.direction + (Math.random() < 0.5 ? 1 : 3)) % 4;
            }

            // Bounds check
            if (this.x < 0 || this.x > width || this.y < 0 || this.y > height) {
                this.reset();
            }
        }

        draw() {
            ctx.beginPath();
            ctx.strokeStyle = this.color;
            ctx.lineWidth = this.width;
            ctx.lineCap = 'round';
            ctx.lineJoin = 'round';

            // Draw shadow for neon effect
            ctx.shadowBlur = 10;
            ctx.shadowColor = this.color;

            if (this.history.length > 0) {
                ctx.moveTo(this.history[0].x, this.history[0].y);
                for (let i = 1; i < this.history.length; i++) {
                    ctx.lineTo(this.history[i].x, this.history[i].y);
                }
                ctx.lineTo(this.x, this.y);
            }
            ctx.stroke();

            // Reset shadow
            ctx.shadowBlur = 0;
        }
    }

    for (let i = 0; i < pipeCount; i++) {
        pipes.push(new Pipe());
    }

    function animate() {
        // Fade out trail
        ctx.fillStyle = 'rgba(10, 10, 10, 0.1)';
        ctx.fillRect(0, 0, width, height);

        pipes.forEach(pipe => {
            pipe.update();
            pipe.draw();
        });

        requestAnimationFrame(animate);
    }

    animate();
});
