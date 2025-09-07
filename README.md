# homebrew-sigrok for M1/M2 Mac

I encountered the M1/M2 Mac problem, I created an unofficial Mac Homebrew package. 
I had to apply several patches to the source code for building with older libraries.

## install PulseView-0.4.2

To install the stable release version of PulseView-0.4.2, please run the following command:
```
brew install olegtarasov/sigrok/pulseview
brew install olegtarasov/sigrok/sigrok-cli
```
## install PulseView (latest HEAD)

If you want to build the latest HEAD, please run the following commands:
```
brew install --HEAD olegtarasov/sigrok/sigrok-firmware-fx2lafw
brew install --HEAD olegtarasov/sigrok/libsigrokdecode
brew install --HEAD olegtarasov/sigrok/libsigrok
brew install --HEAD olegtarasov/sigrok/pulseview
brew install --HEAD olegtarasov/sigrok/sigrok-cli
```

-- takesako
