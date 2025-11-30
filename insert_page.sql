USE ctfd;

INSERT INTO pages (id, title, route, content, draft, hidden, auth_required) 
VALUES (1, 'Home', 'index', '<div class="container" style="min-height: 100vh; display: flex; align-items: center; justify-content: center;">
    <div class="row w-100">
        <div class="col-md-8 offset-md-2 text-center">
            <!-- Logo -->
            <img class="img-fluid mx-auto d-block" style="max-width: 350px; margin-bottom: 10px;" src="/themes/core/static/img/small-logo-without-text.png" alt="L3m0nCTF Logo" />
            
            <!-- Title with Serif Font -->
            <h1 class="text-center" style="font-family: ''Times New Roman'', Times, serif; font-size: 3.5rem; margin-bottom: 20px; color: #e0e0e0;">L3m0n CTF 2025</h1>
            
            <!-- Countdown -->
            <div id="countdown" style="font-family: ''Courier New'', Courier, monospace; color: #ff6b6b; font-size: 1.5rem; margin-bottom: 30px; font-weight: 600;">Loading...</div>

            <!-- Presented By Section -->
            <div class="mb-4">
                <h5 class="text-center" style="color: #b0b0b0; font-weight: 400; line-height: 1.6;">
                    <strong style="color: #ffffff; font-size: 1.2rem;">Presented by</strong><br/><br/>
                    TIFAC-CORE in Cyber Security<br/>
                    Amrita Vishwa Vidyapeetham, Coimbatore
                </h5>
                <div class="mt-3">
                    <a href="https://www.linkedin.com/company/l3m0n-ctf" class="text-decoration-none" style="color: #0077b5; margin: 0 10px;"><i class="fab fa-linkedin fa-2x"></i></a>
                    <a href="https://www.instagram.com/l3m0n.ctf" class="text-decoration-none" style="color: #e4405f; margin: 0 10px;"><i class="fab fa-instagram fa-2x"></i></a>
                </div>
            </div>

            <!-- Action Buttons -->
            <div style="display: flex; justify-content: center; gap: 15px; flex-wrap: wrap; margin-top: 20px;">
                <a href="/challenges" class="btn btn-primary px-4 py-2" style="min-width: 140px;">ENTER ARENA</a>
                <a href="/register" class="btn btn-outline-primary px-4 py-2" style="min-width: 140px;">JOIN NOW</a>
                <a href="https://discord.com/invite/3ZaFbQRY3C" target="_blank" class="btn btn-outline-primary px-4 py-2" style="min-width: 140px; border-color: #5865F2; color: #5865F2;">DISCORD</a>
            </div>
        </div>
    </div>
</div>

<style>
    body { overflow-x: hidden; }
    .navbar { margin-bottom: 0; }
</style>

<script>
setTimeout(function(){
    var e=document.getElementById("countdown");
    if(e){
        var t=new Date("2025-10-18T09:00:00+05:30"),
            n=new Date("2025-12-19T21:00:00+05:30");
        function a(){
            var o=new Date;
            if(o>=n)return void(e.textContent="ENDED");
            if(o>=t)return void(e.textContent="LIVE");
            var d=t-o,
                i=Math.floor(d/864e5),
                r=Math.floor(d%864e5/36e5),
                s=Math.floor(d%36e5/6e4),
                c=Math.floor(d%6e4/1e3);
            e.textContent=i+"D "+r+"H "+s+"M "+c+"S"
        }
        a(),setInterval(a,1e3)
    }
},500);
</script>', 0, 0, 0)
ON DUPLICATE KEY UPDATE content = VALUES(content);
