UPDATE pages SET content = '<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>L3m0n CTF 2025 | Enter the Abyss</title>
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;800&family=JetBrains+Mono:wght@400;700&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <script src="https://cdn.tailwindcss.com"></script>
    
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: {
                        sans: [\"Inter\", \"sans-serif\"],
                        mono: [\"JetBrains Mono\", \"monospace\"],
                    },
                    colors: {
                        lemon: {
                            DEFAULT: \"#ccff00\",
                            glow: \"#d9ff4d\",
                            dim: \"#4d6600\",
                        },
                        obsidian: \"#050505\",
                        glass: \"rgba(20, 20, 20, 0.6)\",
                    },
                    animation: {
                        \"float\": \"float 6s ease-in-out infinite\",
                        \"pulse-glow\": \"pulseGlow 3s infinite\",
                        \"scanline\": \"scanline 8s linear infinite\",
                        \"shimmer\": \"shimmer 2s linear infinite\",
                    },
                    keyframes: {
                        float: {
                            \"0%, 100%\": { transform: \"translateY(0)\" },
                            \"50%\": { transform: \"translateY(-20px)\" },
                        },
                        pulseGlow: {
                            \"0%, 100%\": { boxShadow: \"0 0 20px rgba(204, 255, 0, 0.2)\" },
                            \"50%\": { boxShadow: \"0 0 40px rgba(204, 255, 0, 0.5)\" },
                        },
                        scanline: {
                            \"0%\": { transform: \"translateY(-100%)\" },
                            \"100%\": { transform: \"translateY(100%)\" }
                        },
                        shimmer: {
                            \"0%\": { backgroundPosition: \"-200% 0\" },
                            \"100%\": { backgroundPosition: \"200% 0\" }
                        }
                    }
                }
            }
        }
    </script>

    <style>
        body {
            background-color: #050505; 
            background-image: 
                radial-gradient(circle at 50% 50%, rgba(20, 30, 40, 0.5) 0%, rgba(5, 5, 5, 1) 100%);
            color: #e5e5e5;
            overflow-x: hidden;
        }

        .glass-panel {
            background: rgba(15, 15, 15, 0.4);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.08);
            box-shadow: 0 4px 30px rgba(0, 0, 0, 0.3);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .glass-panel:hover {
            border-color: rgba(204, 255, 0, 0.4);
            transform: translateY(-2px);
            background: rgba(20, 20, 20, 0.6);
            box-shadow: 0 10px 40px rgba(204, 255, 0, 0.1);
        }

        .glitch-text {
            position: relative;
        }
        
        .glitch-text::before,
        .glitch-text::after {
            content: attr(data-text);
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
        }

        .glitch-text::before {
            left: 2px;
            text-shadow: -1px 0 #ff00c1;
            clip: rect(44px, 450px, 56px, 0);
            animation: glitch-anim 5s infinite linear alternate-reverse;
        }

        .glitch-text::after {
            left: -2px;
            text-shadow: -1px 0 #00fff9;
            clip: rect(44px, 450px, 56px, 0);
            animation: glitch-anim2 5s infinite linear alternate-reverse;
        }

        @keyframes glitch-anim {
            0% { clip: rect(14px, 9999px, 127px, 0); }
            5% { clip: rect(34px, 9999px, 12px, 0); }
            100% { clip: rect(84px, 9999px, 87px, 0); }
        }
        
        @keyframes glitch-anim2 {
            0% { clip: rect(84px, 9999px, 14px, 0); }
            100% { clip: rect(12px, 9999px, 34px, 0); }
        }

        ::-webkit-scrollbar { width: 6px; }
        ::-webkit-scrollbar-track { background: #050505; }
        ::-webkit-scrollbar-thumb { background: #333; border-radius: 3px; }
        ::-webkit-scrollbar-thumb:hover { background: #ccff00; }

        .text-glow { text-shadow: 0 0 15px rgba(204, 255, 0, 0.5); }
        .border-gradient { border-image: linear-gradient(to right, #ccff00, transparent) 1; }
        
        .btn-shimmer {
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            background-size: 200% 100%;
            animation: shimmer 2s linear infinite;
        }
        
        .category-badge {
            transition: all 0.3s ease;
        }
        .category-badge:hover {
            transform: scale(1.05);
            box-shadow: 0 0 20px rgba(204, 255, 0, 0.3);
        }
    </style>
</head>
<body class="min-h-screen relative">

    <div class="fixed inset-0 z-[-1] pointer-events-none">
        <div class="absolute top-0 right-0 w-[500px] h-[500px] bg-lemon/5 rounded-full blur-[120px]"></div>
        <div class="absolute bottom-0 left-0 w-[500px] h-[500px] bg-blue-500/5 rounded-full blur-[120px]"></div>
        <div class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[800px] h-[800px] bg-purple-500/3 rounded-full blur-[150px]"></div>
    </div>

    <main class="relative z-10 pt-8 pb-20 px-4 sm:px-6 lg:px-8 max-w-7xl mx-auto">
        
        <div class="grid lg:grid-cols-2 gap-12 items-center mb-24 min-h-[80vh]">
            <div class="order-2 lg:order-1 text-center lg:text-left">
                <div class="inline-block px-3 py-1 mb-4 border border-lemon/30 rounded-full bg-lemon/5">
                    <span class="text-lemon font-mono text-xs font-bold tracking-[0.2em] uppercase">
                        <i class="fas fa-circle text-[8px] mr-2 animate-ping"></i>Live Registration
                    </span>
                </div>
                
                <h1 class="text-6xl md:text-8xl font-black text-white mb-6 leading-tight tracking-tight glitch-text" data-text="L3M0N CTF">
                    L3M0N <br/>
                    <span class="text-transparent bg-clip-text bg-gradient-to-r from-lemon to-white">CTF 2025</span>
                </h1>

                <p class="text-gray-400 text-lg md:text-xl mb-8 max-w-2xl mx-auto lg:mx-0 font-light leading-relaxed">
                    Dive into the digital abyss. Solve the unsolvable.
                    Presented by <span class="text-white font-semibold border-b border-lemon/50">TIFAC-CORE IN CYBER SECURITY</span> & <span class="text-white font-semibold border-b border-lemon/50">Amrita Vishwa Vidyapeetham</span>.
                </p>

                <div class="flex flex-col sm:flex-row gap-4 justify-center lg:justify-start">
                    <a href=\"{{ url_for(\"challenges.listing\") if authed() else url_for(\"auth.login\") }}\" class="group relative px-8 py-4 bg-lemon text-black font-bold text-lg rounded-xl overflow-hidden shadow-[0_0_20px_rgba(204,255,0,0.3)] hover:shadow-[0_0_40px_rgba(204,255,0,0.6)] transition-all transform hover:-translate-y-1 text-center no-underline">
                        <span class="relative z-10 flex items-center justify-center gap-2">
                            ENTER ARENA <i class="fas fa-arrow-right group-hover:translate-x-1 transition-transform"></i>
                        </span>
                        <div class="absolute inset-0 bg-white/30 translate-y-full group-hover:translate-y-0 transition-transform duration-300"></div>
                    </a>
                    
                    <a href="https://discord.gg/your-discord-link" target="_blank" class="px-8 py-4 border border-white/20 text-white font-bold text-lg rounded-xl hover:bg-white/5 transition-all flex items-center justify-center gap-2 no-underline">
                        <i class="fab fa-discord"></i> JOIN DISCORD
                    </a>
                </div>
                
                <!-- Countdown Timer -->
                <div class="mt-10 flex flex-wrap gap-4 justify-center lg:justify-start">
                    <div class="glass-panel px-6 py-4 rounded-xl text-center min-w-[80px]">
                        <div id="days" class="text-3xl font-mono font-bold text-lemon">00</div>
                        <div class="text-xs text-gray-500 uppercase tracking-wider">Days</div>
                    </div>
                    <div class="glass-panel px-6 py-4 rounded-xl text-center min-w-[80px]">
                        <div id="hours" class="text-3xl font-mono font-bold text-white">00</div>
                        <div class="text-xs text-gray-500 uppercase tracking-wider">Hours</div>
                    </div>
                    <div class="glass-panel px-6 py-4 rounded-xl text-center min-w-[80px]">
                        <div id="minutes" class="text-3xl font-mono font-bold text-white">00</div>
                        <div class="text-xs text-gray-500 uppercase tracking-wider">Mins</div>
                    </div>
                    <div class="glass-panel px-6 py-4 rounded-xl text-center min-w-[80px]">
                        <div id="seconds" class="text-3xl font-mono font-bold text-white">00</div>
                        <div class="text-xs text-gray-500 uppercase tracking-wider">Secs</div>
                    </div>
                </div>
            </div>

            <div class="order-1 lg:order-2 flex justify-center relative">
                <div class="absolute inset-0 border border-lemon/10 rounded-full animate-[spin_10s_linear_infinite]"></div>
                <div class="absolute inset-4 border border-white/5 rounded-full animate-[spin_15s_linear_infinite_reverse]"></div>
                
                <div class="relative w-64 h-64 md:w-96 md:h-96 animate-float">
                    <div class="absolute inset-0 bg-lemon blur-[80px] opacity-20 rounded-full"></div>
                    <img src=\"{{ url_for(\"views.files\", path=Configs.ctf_logo) }}\" alt="L3m0n CTF Logo" class="w-full h-full object-contain drop-shadow-[0_0_30px_rgba(204,255,0,0.4)]" onerror="this.src=\"https://api.iconify.design/noto:lemon.svg\"">
                </div>
            </div>
        </div>

        <!-- Challenge Categories Preview -->
        <div class="mb-24">
            <h2 class="text-3xl font-bold text-white text-center mb-4">Challenge Categories</h2>
            <p class="text-gray-400 text-center mb-12 max-w-2xl mx-auto">Test your skills across multiple domains of cybersecurity</p>
            <div class="flex flex-wrap justify-center gap-4">
                <div class="category-badge glass-panel px-6 py-3 rounded-full flex items-center gap-3">
                    <i class="fas fa-globe text-blue-400"></i>
                    <span class="font-semibold">Web</span>
                </div>
                <div class="category-badge glass-panel px-6 py-3 rounded-full flex items-center gap-3">
                    <i class="fas fa-key text-purple-400"></i>
                    <span class="font-semibold">Crypto</span>
                </div>
                <div class="category-badge glass-panel px-6 py-3 rounded-full flex items-center gap-3">
                    <i class="fas fa-microchip text-red-400"></i>
                    <span class="font-semibold">Pwn</span>
                </div>
                <div class="category-badge glass-panel px-6 py-3 rounded-full flex items-center gap-3">
                    <i class="fas fa-bug text-green-400"></i>
                    <span class="font-semibold">Reverse</span>
                </div>
                <div class="category-badge glass-panel px-6 py-3 rounded-full flex items-center gap-3">
                    <i class="fas fa-search text-yellow-400"></i>
                    <span class="font-semibold">Forensics</span>
                </div>
                <div class="category-badge glass-panel px-6 py-3 rounded-full flex items-center gap-3">
                    <i class="fas fa-puzzle-piece text-pink-400"></i>
                    <span class="font-semibold">Misc</span>
                </div>
            </div>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-6 lg:grid-cols-12 gap-6">
            
            <div class="glass-panel p-6 rounded-2xl md:col-span-3 lg:col-span-4 flex flex-col justify-between group">
                <div class="mb-4">
                    <i class="far fa-calendar-alt text-3xl text-lemon mb-2 group-hover:scale-110 transition-transform"></i>
                    <h3 class="text-gray-400 font-mono text-sm uppercase tracking-wider">Timeline</h3>
                </div>
                <div>
                    <p class="text-2xl font-bold text-white">Dec 20 - 21</p>
                    <p class="text-sm text-gray-500">2025 Edition</p>
                </div>
            </div>

            <div class="glass-panel p-6 rounded-2xl md:col-span-3 lg:col-span-4 flex flex-col justify-between group">
                <div class="mb-4">
                    <i class="fas fa-map-marker-alt text-3xl text-red-400 mb-2 group-hover:scale-110 transition-transform"></i>
                    <h3 class="text-gray-400 font-mono text-sm uppercase tracking-wider">Location</h3>
                </div>
                <div>
                    <p class="text-xl font-bold text-white leading-tight">Amrita Vishwa Vidyapeetham</p>
                    <p class="text-sm text-gray-500">Coimbatore, India</p>
                </div>
            </div>

            <div class="glass-panel p-6 rounded-2xl md:col-span-6 lg:col-span-4 flex flex-col justify-between group">
                <div class="mb-4">
                    <i class="fas fa-terminal text-3xl text-blue-400 mb-2 group-hover:scale-110 transition-transform"></i>
                    <h3 class="text-gray-400 font-mono text-sm uppercase tracking-wider">Format</h3>
                </div>
                <div class="flex gap-4">
                    <div>
                        <p class="text-xl font-bold text-white">Jeopardy</p>
                        <p class="text-sm text-gray-500">Style</p>
                    </div>
                    <div class="w-[1px] bg-white/10"></div>
                    <div>
                        <p class="text-xl font-bold text-white">24</p>
                        <p class="text-sm text-gray-500">Hours</p>
                    </div>
                </div>
            </div>

            <div class="glass-panel p-8 rounded-2xl md:col-span-6 lg:col-span-7 relative overflow-hidden group border-lemon/30">
                <div class="absolute top-0 right-0 p-4 opacity-10 group-hover:opacity-20 transition-opacity">
                    <i class="fas fa-trophy text-9xl text-lemon transform rotate-12"></i>
                </div>
                <div class="relative z-10">
                    <h3 class="text-lemon font-mono font-bold uppercase tracking-widest mb-2 flex items-center gap-2">
                        <i class="fas fa-star animate-spin"></i> Prize Pool
                    </h3>
                    <div class="text-5xl md:text-7xl font-black text-white mb-2 text-glow">
                        $14,000+
                    </div>
                    <p class="text-gray-400 max-w-md">
                        Massive rewards in cash, vouchers, and exclusive swag waiting for the top ranked teams.
                    </p>
                </div>
            </div>

            <div class="glass-panel p-8 rounded-2xl md:col-span-6 lg:col-span-5 flex flex-col justify-center relative overflow-hidden group">
                <div class="absolute inset-0 bg-gradient-to-br from-purple-500/10 to-transparent opacity-0 group-hover:opacity-100 transition-opacity"></div>
                <div class="relative z-10">
                    <div class="w-12 h-12 rounded-full bg-white/10 flex items-center justify-center mb-4 group-hover:bg-lemon group-hover:text-black transition-colors">
                        <i class="fas fa-briefcase text-xl"></i>
                    </div>
                    <h3 class="text-2xl font-bold text-white mb-2">Internship Opportunities</h3>
                    <p class="text-gray-400 text-sm">
                        Direct interview access with top cybersecurity firms for high performers.
                    </p>
                </div>
            </div>
        </div>

        <div class="mt-24 text-center border-t border-white/5 pt-12">
            <p class="text-gray-500 font-mono text-sm mb-4">POWERED BY</p>
            <div class="flex flex-wrap justify-center items-center gap-8 md:gap-12 opacity-70 grayscale hover:grayscale-0 transition-all duration-500">
                <div class="text-xl font-bold text-white flex items-center gap-2">
                    <i class="fas fa-university"></i> AMRITA VISHWA VIDYAPEETHAM
                </div>
                <div class="h-4 w-[1px] bg-white/20 hidden md:block"></div>
                <div class="text-xl font-bold text-white flex items-center gap-2">
                    <i class="fas fa-shield-alt"></i> TIFAC-CORE IN CYBER SECURITY
                </div>
            </div>
            
            <div class="mt-12 flex justify-center gap-6">
                <a href="#" class="text-gray-400 hover:text-lemon transition-colors"><i class="fab fa-twitter text-xl"></i></a>
                <a href="#" class="text-gray-400 hover:text-lemon transition-colors"><i class="fab fa-instagram text-xl"></i></a>
                <a href="#" class="text-gray-400 hover:text-lemon transition-colors"><i class="fab fa-linkedin text-xl"></i></a>
            </div>
            
            <p class="text-gray-600 text-xs mt-8 font-mono">
                &copy; 2025 L3m0n CTF. All systems operational.
            </p>
        </div>

    </main>

    <script>
        document.addEventListener(\"DOMContentLoaded\", () => {
            const countDownDate = new Date(\"Dec 20, 2025 09:00:00\").getTime();

            const x = setInterval(function() {
                const now = new Date().getTime();
                const distance = countDownDate - now;

                const days = Math.floor(distance / (1000 * 60 * 60 * 24));
                const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
                const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
                const seconds = Math.floor((distance % (1000 * 60)) / 1000);

                document.getElementById(\"days\").textContent = days < 10 ? \"0\" + days : days;
                document.getElementById(\"hours\").textContent = hours < 10 ? \"0\" + hours : hours;
                document.getElementById(\"minutes\").textContent = minutes < 10 ? \"0\" + minutes : minutes;
                document.getElementById(\"seconds\").textContent = seconds < 10 ? \"0\" + seconds : seconds;

                if (distance < 0) {
                    clearInterval(x);
                    document.getElementById(\"days\").textContent = \"00\";
                    document.getElementById(\"hours\").textContent = \"00\";
                    document.getElementById(\"minutes\").textContent = \"00\";
                    document.getElementById(\"seconds\").textContent = \"00\";
                }
            }, 1000);
        });
    </script>
</body>
</html>' WHERE route = 'index';
