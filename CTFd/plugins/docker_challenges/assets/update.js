CTFd.plugin.run((_CTFd) => {
    const $ = _CTFd.lib.$
    const md = _CTFd.lib.markdown()
    
    $(document).ready(function() {
        $('[data-toggle="tooltip"]').tooltip();
        
        // Handle challenge type radio button changes
        $('input[name="challenge_type"]').change(function() {
            if ($(this).val() === 'multi') {
                $('#multi_image_options').show();
                $('#single_image_options').hide();
                // Disable single image connection type
                $('#connection_type_single').prop('disabled', true);
                $('#connection_type').prop('disabled', false);
            } else {
                $('#multi_image_options').hide();
                $('#single_image_options').show();
                // Enable single image connection type
                $('#connection_type_single').prop('disabled', false);
                $('#connection_type').prop('disabled', true);
            }
        });
        
        // Handle docker selection change to populate primary service options
        $('#dockerimage_select').change(function() {
            const selectedOption = $(this).find('option:selected');
            const itemType = selectedOption.attr('data-type');
            
            if (itemType === 'multi') {
                // Multi-image selected - populate primary service options
                const services = selectedOption.attr('data-services');
                if (services) {
                    const serviceList = services.split(',');
                    const primaryServiceSelect = $('#primary_service');
                    const currentPrimary = CHALLENGE_DATA.primary_service;
                    
                    primaryServiceSelect.empty();
                    primaryServiceSelect.append('<option value="">Auto-detect</option>');
                    
                    serviceList.forEach(function(service) {
                        const option = $('<option>').val(service).text(service);
                        if (service === currentPrimary) {
                            option.prop('selected', true);
                        }
                        primaryServiceSelect.append(option);
                    });
                }
                
                // Auto-select multi-image challenge type
                $('#multi_image').prop('checked', true).trigger('change');
            } else if (itemType === 'single') {
                // Single image selected - auto-select single challenge type
                $('#single_image').prop('checked', true).trigger('change');
            }
        });
        
        // Load Docker images and servers
        $.getJSON("/api/v1/docker", function(result) {
            if (result.success) {
                // Group images by server
                const serverGroups = {};
                let selectedValue = null;
                
                $.each(result['data'], function(i, item) {
                    if (item.error) {
                        // Add error items directly
                        $("#dockerimage_select").append(
                            $("<option />").val(item.name).text(item.name).attr('disabled', true)
                        );
                    } else {
                        // Group by server
                        if (!serverGroups[item.server_name]) {
                            serverGroups[item.server_name] = [];
                        }
                        serverGroups[item.server_name].push(item);
                    }
                });
                
                // Add grouped options
                Object.keys(serverGroups).sort().forEach(function(serverName) {
                    // Add server group header
                    const optgroup = $("<optgroup />").attr('label', serverName);
                    
                    serverGroups[serverName].forEach(function(item) {
                        const option = $("<option />").val(item.name);
                        
                        if (item.type === 'multi') {
                            // Multi-image option
                            option.text(`[MULTI] ${item.project_name} (${item.image_count} images)`)
                                  .attr('data-type', 'multi')
                                  .attr('data-server-id', item.server_id)
                                  .attr('data-server-name', item.server_name)
                                  .attr('data-project-name', item.project_name)
                                  .attr('data-images', item.images.join(','))
                                  .attr('data-services', item.services.join(','))
                                  .attr('data-image-count', item.image_count);
                            
                            // Check if this matches current challenge (multi-image)
                            if (CHALLENGE_DATA.challenge_type === 'multi' && 
                                CHALLENGE_DATA.docker_images && 
                                item.server_name === CHALLENGE_DATA.server_name &&
                                arraysEqual(item.images.sort(), CHALLENGE_DATA.docker_images.sort())) {
                                selectedValue = item.name;
                            }
                        } else {
                            // Single image option
                            option.text(item.image_name)
                                  .attr('data-type', 'single')
                                  .attr('data-server-id', item.server_id)
                                  .attr('data-server-name', item.server_name)
                                  .attr('data-image-name', item.image_name);
                            
                            // Check if this matches current challenge (single image)
                            if (CHALLENGE_DATA.challenge_type === 'single' && 
                                item.image_name === CHALLENGE_DATA.docker_image &&
                                item.server_name === CHALLENGE_DATA.server_name) {
                                selectedValue = item.name;
                            }
                        }
                        
                        optgroup.append(option);
                    });
                    
                    $("#dockerimage_select").append(optgroup);
                });
                
                // Set selected value if found
                if (selectedValue) {
                    $("#dockerimage_select").val(selectedValue).trigger('change');
                }
                
                // If no servers available, show error
                if (Object.keys(serverGroups).length === 0 && $("#dockerimage_select option").length === 0) {
                    $("#dockerimage_select").prop('disabled', true);
                    $("label[for='DockerImage']").text('Docker Image - No servers configured!')
                }
            } else {
                // Handle error case
                $("#dockerimage_select").prop('disabled', true);
                $("label[for='DockerImage']").text('Docker Image - Error loading servers!')
                $("#dockerimage_select").append($("<option />").val('ERROR').text(result.data[0].name || 'Error loading Docker servers').attr('disabled', true));
            }
        }).fail(function() {
            // Handle AJAX failure
            $("#dockerimage_select").prop('disabled', true);
            $("label[for='DockerImage']").text('Docker Image - Connection Error!')
            $("#dockerimage_select").append($("<option />").val('ERROR').text('Failed to connect to Docker API').attr('disabled', true));
        });
        
        // Trigger initial state based on loaded challenge type
        $('input[name="challenge_type"]:checked').trigger('change');
    });
    
    // Helper function to compare arrays
    function arraysEqual(a, b) {
        if (a.length !== b.length) return false;
        for (let i = 0; i < a.length; i++) {
            if (a[i] !== b[i]) return false;
        }
        return true;
    }
});