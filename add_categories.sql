UPDATE pages SET content = REPLACE(content, 
'<span class="font-semibold">Misc</span>
                </div>
            </div>
        </div>',
'<span class="font-semibold">Misc</span>
                </div>
                <div class="category-badge glass-panel px-6 py-3 rounded-full flex items-center gap-3">
                    <i class="fas fa-user-secret text-cyan-400"></i>
                    <span class="font-semibold">OSINT</span>
                </div>
                <div class="category-badge glass-panel px-6 py-3 rounded-full flex items-center gap-3">
                    <i class="fas fa-map-marked-alt text-orange-400"></i>
                    <span class="font-semibold">GeoSINT</span>
                </div>
            </div>
        </div>') WHERE route = 'index';
