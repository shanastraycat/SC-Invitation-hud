//==================  CONFIGS ======================

string facebook="https://www.youtube.com/watch?v=4v-nxWJBrUA";
string linktext="Do you want to open this page";
string groupid="a4236620-ef05-3edc-f720-19a33e4eaf09";
string inviteText ="Greeting message, You have been invited on day of month for this event at this time";

//=================================================

key owner;
string sound="6005e358-33fd-d08b-012f-6110ab27a413";
string loc;
string txt;
integer gListener;    
string thisScrip;

give()
{
    list inventoryItems;
    integer inventoryNumber = llGetInventoryNumber(INVENTORY_ALL);
    string text = llGetObjectName(); 
    
    integer index;
    for ( ; index < inventoryNumber; ++index )
    {
        string itemName = llGetInventoryName(INVENTORY_ALL, index);
        
        if (itemName != thisScrip)
        {
            if (llGetInventoryPermMask(itemName, MASK_OWNER) & PERM_COPY)
            {
                inventoryItems += itemName;
            }
            else
            {  
                llOwnerSay("Unable to copy the item named '" + itemName + "'.");
            }
        }
    }
    
    if (inventoryItems == [] )
    {
        llInstantMessage(llDetectedKey(0),"Error");
    }
    else
    {
        llGiveInventoryList(llDetectedKey(0), llGetObjectName(), inventoryItems);
        llInstantMessage(llDetectedKey(0), "Items sent can be found in your inventory, in a folder called '"+ text +"'");
    }
}


default
{
    state_entry()
    {
        llOwnerSay(inviteText);
        llPreloadSound(sound);
        owner = llGetOwner();
        txt = llGetInventoryName(INVENTORY_TEXTURE,0);
        loc = llGetInventoryName(INVENTORY_LANDMARK, 0);
        thisScrip = llGetScriptName();
        llRequestPermissions(owner, PERMISSION_ATTACH );
    }
    
    changed(integer change)
    {
        if (change & (CHANGED_OWNER))
        llResetScript();
    }
    
    attach(key attached)
    {
        if (attached != NULL_KEY)
        llResetScript();
    }
    
    on_rez(integer start_param)
    {
        if(llGetAttached() > 0)
        {
            llResetScript();
        }
        else
        {
            llOwnerSay("This object must be attach as hud, else it wont work properly");    
        }
    }
    
    control(key id,integer held, integer change)
    {
        return;
    }
    
    run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_TAKE_CONTROLS)
        llTakeControls(CONTROL_UP,TRUE,TRUE);
        
        if (perm & PERMISSION_TELEPORT)
        {
            llTeleportAgent(owner, loc, ZERO_VECTOR, ZERO_VECTOR);
        }
    }
    
    touch_start(integer total_number)
    {
    string name = llGetLinkName(llDetectedLinkNumber(0));
    
        if(name == llGetObjectName()) {
            return;
        } 
        else if(name == "btn-fb") {
            llPlaySound(sound,1.0); 
            llLoadURL(owner,linktext,facebook);  
        } 
        else if(name == "btn-giver"){
            give();  
        }
        else if(name == "btn-tp") {
            llPlaySound(sound,1.0);
            llRequestPermissions(owner, (PERMISSION_TELEPORT));
        }
        else if(name == "btn-detach") {
            llPlaySound(sound,1.0);
            llDetachFromAvatar( ); 
        }
        else if(name == "btn-group") {
            llPlaySound(sound,1.0);
            llListenRemove(gListener);
            gListener = llListen(-99, "",owner, "");
            llDialog(owner, "Click here to join the group --> secondlife:///app/group/"+groupid+"/about", ["Done"], -99);
        }
        else if(name == "btn-detach") {
            llPlaySound(sound,1.0);
            llDetachFromAvatar( ); 
        }
    }
}
