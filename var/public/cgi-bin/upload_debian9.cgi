#!/usr/bin/perl

local($fulldestdir)="/var/public/tmp";
use CGI ;
if($TempFile::TMPDIRECTORY){ $TempFile::TMPDIRECTORY = $fulldestdir; }
elsif($CGITempFile::TMPDIRECTORY){ $CGITempFile::TMPDIRECTORY = $fulldestdir; }
my $query=new CGI;
$|=1;

require "general.pl";
&PrintHeader();
local(%formdata)=&GetFormData();
local(%osinfo)=();

$osinfo{CMDLINE}=$query->param('CMDLINE');
$osinfo{OS}=$query->param('OS');
$osinfo{FLAVOR}=$query->param('OSFLAVOR');
$osinfo{ISOPATH}=$query->param('FILE1');
$osinfo{MOUNT}=$query->param('MOUNT');
$osinfo{MOUNTONBOOT}=$query->param('MOUNTONBOOT');
$osinfo{KERNEL}="memdisk";
$osinfo{NETBOOTIMAGE}="debian9/$osinfo{FLAVOR}/".$query->param('NETBOOTIMAGE');

local($osdir)="/var/public/tftproot/debian9";
local($result)=&CreateDir($osdir);
if ($result)
{
  &PrintError("Could not create os directory");
  exit 1;
}

local($flavordir)=$TFTPDIR."/".$osinfo{OS}."/".$osinfo{FLAVOR};
local($result)=&CreateDir($flavordir);
if ($result)
{
  &PrintError("Could not create flavor directory");
  exit 1;
}

local($filecount)=1;
for my $k ($query->param())
{
   next unless my $u=$query->upload($k);
   local($tmpfilename)=$query->tmpFileName($u);
   my ($filename)=$query->uploadInfo($u)->{'Content-Disposition'}=~/filename="(.+?)"/i;
   $filename=~s/^.*\\([^\\]*)$/$1/;
   $destfile="$flavordir/netboot.tar.gz";
   close($filename);
   local($result)=rename($tmpfilename,$destfile);
   if (!$result)
   {
     &PrintError("Could not rename temporary file $tmpfilename to $destfile");
     exit 3;
   }
   local($result)=chmod(0644,$destfile);
   if ($result ne 1)
   {
     &PrintError("Could not chmod 0644 the file $destfile");
     exit 4;
   }
   $osinfo{"FILE_".$filecount}=$destfile;
   $filecount++;
}

require "os/debian9.pl";
%formdata=();
$formdata{OS}="debian9";
$formdata{OSFLAVOR}=$osinfo{FLAVOR};
$formdata{FILE1}=$osinfo{ISOPATH};
$formdata{NETBOOTIMAGE}=$osinfo{NETBOOTIMAGE};
$formdata{MOUNT}=$osinfo{MOUNT};
$formdata{MOUNTONBOOT}=$osinfo{MOUNTONBOOT};
$formdata{DIR_1}=$flavordir;

local($result)=&debian9_ImportOS("debian9");
if ($result)
{
  &PrintError("Could Import OS debian 8 with flavor $osinfo{FLAVOR}");
  exit 4;
}

# &PrintSuccess("Import of debian9 operating system $osinfo{FLAVOR} succesfull");
