// Rotating Rings Media Display Script
// This script sets up media on a prim face to display the rotating rings webpage

// Configuration
integer MEDIA_FACE = 0;  // Which face to apply media to (0 = first face)
string WEB_URL = "http://your-domain.com/index.html";  // Replace with your actual web URL
integer AUTO_SCALE = TRUE;  // Auto-scale media to fit prim face
float MEDIA_WIDTH = 512.0;  // Media texture width
float MEDIA_HEIGHT = 512.0; // Media texture height

default
{
    state_entry()
    {
        llOwnerSay("Initializing Rotating Rings Media Display...");
        setupMedia();
    }
    
    touch_start(integer total_number)
    {
        // Allow touching to refresh/reload the media
        if (llDetectedKey(0) == llGetOwner())
        {
            llOwnerSay("Refreshing media display...");
            setupMedia();
        }
    }
    
    changed(integer change)
    {
        // Reinitialize media if prim is rezzed or reset
        if (change & (CHANGED_REGION | CHANGED_REGION_START | CHANGED_TELEPORT))
        {
            llSleep(2.0); // Wait for region to stabilize
            setupMedia();
        }
    }
}

setupMedia()
{
    // Clear any existing media first
    llClearPrimMedia(MEDIA_FACE);
    
    // Set up the media parameters
    list media_params = [
        PRIM_MEDIA_AUTO_LOOP, TRUE,
        PRIM_MEDIA_AUTO_PLAY, TRUE,
        PRIM_MEDIA_AUTO_SCALE, AUTO_SCALE,
        PRIM_MEDIA_AUTO_ZOOM, FALSE,
        PRIM_MEDIA_FIRST_CLICK_INTERACT, FALSE,
        PRIM_MEDIA_WIDTH_PIXELS, (integer)MEDIA_WIDTH,
        PRIM_MEDIA_HEIGHT_PIXELS, (integer)MEDIA_HEIGHT,
        PRIM_MEDIA_HOME_URL, WEB_URL,
        PRIM_MEDIA_CURRENT_URL, WEB_URL,
        PRIM_MEDIA_PERMS_INTERACT, PRIM_MEDIA_PERM_OWNER | PRIM_MEDIA_PERM_GROUP,
        PRIM_MEDIA_PERMS_CONTROL, PRIM_MEDIA_PERM_OWNER | PRIM_MEDIA_PERM_GROUP,
        PRIM_MEDIA_CONTROLS, PRIM_MEDIA_CONTROLS_MINI
    ];
    
    // Apply media parameters to the specified face
    integer result = llSetPrimMediaParams(MEDIA_FACE, media_params);
    
    if (result == 0)
    {
        llOwnerSay("✓ Media successfully applied to face " + (string)MEDIA_FACE);
        llOwnerSay("✓ Displaying: " + WEB_URL);
        llOwnerSay("✓ Touch to refresh media");
        
        // Set whitelist separately to avoid list nesting issues
        llSetPrimMediaParams(MEDIA_FACE, [
            PRIM_MEDIA_WHITELIST_ENABLE, TRUE,
            PRIM_MEDIA_WHITELIST, WEB_URL
        ]);
    }
    else
    {
        llOwnerSay("✗ Failed to set media parameters. Error code: " + (string)result);
        llOwnerSay("Check that the prim face exists and media is enabled.");
    }
}

// Alternative function using llSetLinkMedia for multi-prim linksets
setupLinkMedia()
{
    list media_params = [
        PRIM_MEDIA_AUTO_LOOP, TRUE,
        PRIM_MEDIA_AUTO_PLAY, TRUE,
        PRIM_MEDIA_AUTO_SCALE, AUTO_SCALE,
        PRIM_MEDIA_HOME_URL, WEB_URL,
        PRIM_MEDIA_CURRENT_URL, WEB_URL,
        PRIM_MEDIA_WIDTH_PIXELS, (integer)MEDIA_WIDTH,
        PRIM_MEDIA_HEIGHT_PIXELS, (integer)MEDIA_HEIGHT,
        PRIM_MEDIA_PERMS_INTERACT, PRIM_MEDIA_PERM_OWNER | PRIM_MEDIA_PERM_GROUP,
        PRIM_MEDIA_PERMS_CONTROL, PRIM_MEDIA_PERM_OWNER | PRIM_MEDIA_PERM_GROUP
    ];
    
    integer result = llSetLinkMedia(LINK_THIS, MEDIA_FACE, media_params);
    
    if (result == 0)
    {
        llOwnerSay("✓ Link media successfully applied");
    }
    else
    {
        llOwnerSay("✗ Failed to set link media. Error code: " + (string)result);
    }
} 