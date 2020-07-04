#!usr/bin/perl
#Created by ABDUL SATTAR MAPARA
use POSIX qw(strftime);

print $date;
$valid = 0;
$tempvalid=0;
print "ENTER USERNAME:\nFORMAT:MINIMUM LENGTH-4 CHARACTERS MAXIMUM LENGTH-10 CHARACTERS(ALPHABETS,NUMBERS)\n";
my $username=<STDIN>;
chomp($username);
while($tempvalid == 0)
{
	if($username =~ m/^[a-zA-Z0-9]{4,10}$/)
	{
		$tempvalid=1;
	}
	else
	{
		print "ENTER A VALID USERNAME\n";
		$username=<STDIN>;
		chomp($username);
	}
}
print "ENTER YOUR EMAIL-ID\n";
my $email = <STDIN>;
chomp($email);
$tempvalid=0;
while($tempvalid == 0)
{
	if ($email =~ m/^[a-z]{1}+[a-z0-9._]{2,}+@+[a-z]+\.+[a-z]{2,4}$/)
	{
		$tempvalid=1;#valid
	}
	else
	{
		print "ENTER A VALID EMAIL-ID\n";
		$email = <STDIN>;
		chomp($email);
	}
}
print "ENTER YOUR PHONE NUMBER(MOBILE):\n";
my $phone= <STDIN>;
chomp($phone);
$tempvalid=0;
while($tempvalid==0)
{
	if($phone =~ m/^[7-9]{1}[0-9]{9}$/)
	{
		$tempvalid=1;
	}
	else
	{
		print "ENTER A VALID PHONE NUMBER\n";
		$phone = <STDIN>;
		chomp($phone);
	}
}
print "ENTER DATE OF BIRTH YYYY/MM/DD\n";
my $dob=<STDIN>;
chomp($dob);
$tempvalid=0;
while($tempvalid==0)
{
	if($dob =~ m/^[0-9]{4}\/[0-9]{1,2}\/[0-9]{1,2}$/)
	{
		
		$tempvalid=1;
	}
	else
	{
		print "ENTER A VALID DATE\n";
		$dob=<STDIN>;
		chomp($dob);
	}
}

my $date = strftime "%Y/%m/%d", localtime;
$tempvalid=0;
my ($Y,$M,$D);
do
{
	($Y,$M,$D) = split(m{/},$dob);
	if($M > 12 || $M < 1 || $Y < 1900 || $D < 1 || $D > 31)
	{
		$tempvalid=0;
		print "ENTER A VALID DATE\n";
		$dob=<STDIN>;
		chomp($dob);
	}
	else
	{
		$tempvalid=1;
	}
}while($tempvalid==0);
my ($Y_,$M_,$D_) = split(m{/},$date);
print "SYSTEM DATE $date\n";
my $sub_year = $Y_-$Y;
if(($sub_year > 18 ) || ($sub_year==18 && $M < $M_) || ( $M == $M_ && $D <= $D_ ) )
{
	print "VALID AGE!\n";
	$valid=1;
	print "!!! INFORMATION VALIDATED !!!\n";
	open (my $fh,">>","Info.txt") or die "UNABLE TO OPEN THE FILE";
	print $fh "$username $email $phone $dob\n";
	close $fh;
}
else
{
	print "INVALID AGE\n";
}
	






