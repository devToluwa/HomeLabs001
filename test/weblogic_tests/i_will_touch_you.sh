#!/bin/sh

#
# Generated on Wed Dec 10 15:26:46 GMT 2025
# Start of user configurable variables
#
LANG=C
export LANG

#Trap to cleanup cookie file in case of unexpected exits.
trap 'rm -f $COOKIE_FILE; exit 1' 1 2 3 6 

# Path to wget command
WGET=/usr/bin/wget

# Log directory and file
LOGDIR=.
LOGFILE=$LOGDIR/wgetlog-$(date +%m-%d-%y-%H:%M).log

# Print wget version info 
echo "Wget version info: 
------------------------------
$($WGET -V) 
------------------------------" > "$LOGFILE" 2>&1 

# Location of cookie file 
COOKIE_FILE=$(mktemp -t wget_sh_XXXXXX) >> "$LOGFILE" 2>&1 
if [ $? -ne 0 ] || [ -z "$COOKIE_FILE" ] 
then 
 echo "Temporary cookie file creation failed. See $LOGFILE for more details." |  tee -a "$LOGFILE" 
 exit 1 
fi 
echo "Created temporary cookie file $COOKIE_FILE" >> "$LOGFILE" 

# Output directory and file
OUTPUT_DIR=.
#
# End of user configurable variable
#

 $WGET --load-cookies="$COOKIE_FILE" "https://edelivery.oracle.com/ocom/softwareDownload?fileName=fmw_15.1.1.0.0_wls_generic.zip&token=R3pXU3d3WGRIaW1WVDZhU0pEYVh3ZyE6OiFmaWxlSWQ9MTIzMDg0OTgxJmZpbGVTZXRDaWQ9MTIwMDIzNCZyZWxlYXNlQ2lkcz0xMTczMTcyJmRvd25sb2FkVHlwZT05NTc2MSZhZ3JlZW1lbnRJZD0xMjM2ODYyMiZlbWFpbEFkZHJlc3M9b3NkY19ub25fc3NvX3VzZXJAb3JhY2xlLmNvbSZ1c2VyTmFtZT1FUEQtT1NEQ19OT05fU1NPX1VTRVJAT1JBQ0xFLkNPTSZpcEFkZHJlc3M9MTQuMTM3LjE3NC4yMiZ1c2VyQWdlbnQ9TW96aWxsYS81LjAgKFdpbmRvd3MgTlQgMTAuMDsgV2luNjQ7IHg2NCkgQXBwbGVXZWJLaXQvNTM3LjM2IChLSFRNTCwgbGlrZSBHZWNrbykgQ2hyb21lLzE0My4wLjAuMCBTYWZhcmkvNTM3LjM2IEVkZy8xNDMuMC4wLjAmY291bnRyeUNvZGU9VVMmZGxwQ2lkcz0xMjAyNzEyJmFwcGxpY2F0aW9uSWQ9OSZzc295bj1OJnF1ZXJ5U3RyaW5nPWRscF9jaWQsMTIwMjcxMiFyZWxfY2lkLDExNzMxNzI" -O "$OUTPUT_DIR/fmw_15.1.1.0.0_wls_generic.zip" >> "$LOGFILE" 2>&1 

# Cleanup
rm -f "$COOKIE_FILE" 
echo "Removed temporary cookie file $COOKIE_FILE" >> "$LOGFILE" 


