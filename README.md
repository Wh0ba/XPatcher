# XPatcher
GUI front-end for flips, libppf, xdelta, and libRUP patching libraries 

This app allows you to apply patches to files on your iOS devices , mostly used to apply rom hacks to video game roms 

With a simple to use interface to make it as user-friendly as possible 

This project is Licenses under GPL to be compatible with the other Licenses used in the code bases and libraries used.
Full info about Licenses can be found under [Resources/licenses/Licenses.txt](Resources/licenses/Licenses.txt)

### About the project

The app itself is written in pure Objective-C because it's the best (⌐■_■)
While the libraries are a mixer of C and C++

I started this project when i was 17 and kinda dumped it because I was bored at that time
But i finally decided to finish it 3 years later (I'm soon to be 20 while writing thisヾ(•ω•`)o )

Most of the code I had to write on my IPhone that's way it's really messy , I mostly memerized the methods and function calls and sometimes used the offical documentaion, Since there was no auto-complete or anything like that.

## Compiling 

To compile this project you simply need to first install theos https://github.com/theos/theos
And then clone and run make package (to generate a .deb)

To convert it into an ipa you can use [my script deb2ipa.sh](https://gist.github.com/Wh0ba/90cdb675c101e9b9eb3b80585f54b93c)
Simply put the script in the packages folder and then run `./deb2ipa.sh` from within the folder and follow the instructions displayed in the script

This will result in a .ipa archive in packages/ipa/ folder which you can side load and install to your iOS Device (Using AltStore or other signing services)


Wh0ba 2017-2020©
