#!/usr/local/bin/perl
#Kyle Sutherland
#CMSC 416

#This program runs in the format:
#     perl eliza.pl

#This is an eliza program that attempts to use regular expressions to act as a 
#digital therapist.  It runs from the command line and responds to the inputs 
#from the user.  The user is to respond in conversation to what the therapist 
#says and answer its questions about how life is.  The user is expected to use 
#complete sentences and play along with the program.  The program will parse the 
#response text and look for trigger words and phrases to respond to.  It can 
#grab certain phrases such as "I feel ______" and respond with the pulled word.
#For example, if the user says "I feel sad." then the machine might respond with
#"Do you think it's helpful to feel sad?" It also reformulates the pronouns in 
#the user's text and responds in a way that is more appopriate and semantically 
#correct.  The program also uses random switches to choose one of several 
#responses to the user's prompt so that it feels more like the program has an 
#intelligence and isn't just repeating the same thing over and over.  

#the program runs through as a loop and uses regex to check and analyze the user 
#input and continues to run until the user enters "stop" or says goodbye to the 
#therapist.  If the user says bye then says it says goodbye to the user and quits.



use Switch;
print STDOUT "Hello. I am Eliza, your therapist. What's your name?\n"; #introduce self
$line = <STDIN>;
my $name = "";
if ($line=~m/My name is (.*)\b/){ #get user's name
	print "Hello $1. It's nice to meet you.\n"; #more polite if the patient uses a complete sentence.
	$name = ucfirst($1); #save name
}
elsif ($line=~m/(.*)\b/){#get user's name
	print "Hello $1\n";
	$name = ucfirst($1);
}
print "How can I help you today?\n";
$line = <STDIN>;
while ($line ne "stop"){
	$line=~s/you/ElIzAtHeRaPiSt/; #recognizes trying to talk to the therapist and extracts out the word
	$line=~s/(I'm)|(I am)/you are/i; #flip around I am
	$line=~s/(\bme\b)/you/i; #flip around me
	$line=~s/(\bmy\b)/your/i; #flip around my
	$line=~s/myself/yourself/i; #flip around myself
	if ($line=~m/(kill\b|murder|abuse)/i){ #trigger words for danger
		print "$name, do I need to alert the authorities?";
	}
	elsif ($line=~m/I (don't|do not) want to talk about/i){
		print "What would you like to talk about, then?";
	}
	elsif($line=~m/(stress|anxiety|anxious)/i){ #trigger word stress/anxiety
		$stress = $1;
		$stress =~s/ous/ety/i;  #turn anxious into anxiety
		$rando = int(rand(2));
		switch($rando){
			case 0 { print "Proper diet and exercise can help to combat $stress." }
			case 1 { print "Resting more and relaxing is crucial to mental health." }
		}
	}
	elsif($line=~m/bye/i){ #escape word
		print "Goodbye.  Thanks for chatting.  Come back anytime $name!\n";
		last;
	}
	elsif ($line=~m/(I) feel (.*)/i){ #trigger word feel
		$ir=$2;
		$ir=~s/(\bI\b)/you/i; 
		$rando = int(rand(2));
		switch($rando){
			case 0 { print "Why do you feel $ir?" }
			case 1 { print "Do you think it's helpful to feel $ir?" }
		}
	}
	elsif ($line=~m/I (want|need)( .*)/i){ #identifies wants and needs and comes up with a response.  works with verbs or nouns
		$rando = int(rand(4));
		switch($rando){
			case 0 { print "And what makes you $1$2?"; }
			case 1 { print "What if you never got$2?" }
			case 2 { print "What would it mean to you if you got$2?"}
			case 3 { print "Have you $1ed$2 for a while now?" }
		}
	}
	elsif ($line=~m/(I've|I have) been ([a-z]+ing)( )?.*( )?(a lot|lately|recently|as of late|sometimes)?/i){ #been doing stuff
		print "Do you think your $2 is a problem?";
	}
	elsif ($line=~m/(you are) (.*)/i){ #grabs 'I am __'
		$ir=$2;
		$ir=~s/(\bI\b)/you/i; 
		$rando = int(rand(4));
		switch($rando){ #pick a response, seems less scripted
			case 0 { print "What makes you think you're $ir?" }
			case 1 { print "Is being $ir necessarily a bad thing?" }
			case 2 { print "In what way are you $ir?"}
			case 3 { print "Why are you $ir?" }
		}
	}
	elsif ($line=~m/I do/i){ #grabs I do and I do not, gives a generic response
		print "Why is that?";
	}
	elsif ($line=~m/([a-z]+)s you (.*)/i){ #generic verbs, singluar (makes me, etc.)
		$does = "does this";
		$have = "Has this";
		print "And why $does $1 you $2?" ;
	}
	elsif ($line=~m/([a-z]+) you (.*)/i){ #generic verbs, plural (make me, etc.)
		$does = "do they";
		$have = "Have they";
		print "And why $does $1 you $2?" ;
	} 
	elsif ($line=~m/mom|dad|mother|father|parent/i){ #checks for divorce
		print "Are your parents still together?";
	}
	elsif ($line=~m/(great )?(brother|sister|sibling|uncle|aunt|cousin|grandmother|grandfather|friend)/i){ #other family/friend
		print "What's your $1$2's name?\n"; #ask name
		$line = <STDIN>;
		if ($line=~m/(name is|name's|named) (.*)\b/){
			$family = ucfirst($1);
		}
		elsif ($line=~m/(.*)\b/){
			$family = ucfirst($1);
		}
		print "Are you and $family close?"; #prod more about person
	}
	
	elsif ($line=~m/I ([A-Za-z]+)e( .*)?/i){ #verbs that end in e
		print "Tell me more about your $1ings."
	}
	elsif ($line=~m/I ([a-zA-Z]+)( .*)?/i){ #verbs that don't end in e
		print "Care to elaborate on your $1s?";
	}
	elsif ($line =~m/ElIzAtHeRaPiSt/){ #recognizes saved word for the therapist
		$rando = int(rand(2));
		switch($rando){
			case 0 { print "We're not here to talk about me." }
			case 1 { print "Let's talk more about you." }
		}
	}
	elsif ($line =~m/^\s*$/){ #blank input
		print "I can't help you if you won't talk to me.";
	}
	else { #in case text isn't matched
		my $rando = int(rand(5));
		switch($rando){ #random response, seems less repeated
			case 0 { print "Could I get you to clarify that a little more?" }
			case 1 { print "Tell me more." }
			case 2 { print "How does that make you feel?" }
			case 3 { print "That is interesting.  Please continue." }
			case 4 { print "Does talking about this bother you?" }
		}
	}
	print "\n"; #newline for the next input
	$line = <STDIN>;
}