# Useful Notes

## Generate genesis
```
deathstar ; su baggins ; cd ~/Genesis-H0
python2 genesis.py -a quark -z "The end of the world order as we know it" -t 1643187777 -b 0x1e0ffff0 -v 50```
````
This will find a QUARK genesis hash, but the merkle hash is wrong so we use older version:
```
cd ~/Genesis-H0-bak
python2 genesis.py -a scrypt -z "The end of the world order as we know it" -t 1643187777 -b 0x1e0ffff0 -v 50```
````
Which will produce correct merkle key, we can then stop the scripts before finding scrypt genesis (not needed)

## Generate spork key
```openssl ecparam -genkey -name secp256k1 -text -noout -outform DER | xxd -p -c 1000 | sed 's/41534e31204f49443a20736563703235366b310a30740201010420/PrivKey: /' | sed 's/a00706052b8104000aa144034200/'$'\nPubKey: /'```

## Preparing repo
*REMOVE /fork DIRECTORY AND COMMIT BEFORE SQUASHING*

We can also remove our custom unofficial fixes for build system
- c458b9257961d031573cc2379594e7553a7fa546	[build] Skip https checks for dependency downloads
- f47bf1cc3a07261ef9ec17d9a265978205b2fc44	Fix download path for Boost 1.64.0 dependency
- f67329bde58e412c19107bd675077a7fc9bd73a5	Fix download path for QT 5.9.7 dependency

And of course "mnSync HACK" commit if present, or commit UNHACK :)

## Seed nodes
Copy stripped binaries to ~/public as baggins on cortez, log in to the seednode and run:
```cortez-cli stop ; sleep 5 ; killall -9 cortezd ; rm cortez* ; wget http://hulk.veles.network/public/cortezd ; wget http://hulk.veles.network/public/cortez-cli ; chmod +x cortez* ; cp cortez* /usr/local/bin/ ; nano ~/.cortez/cortez.conf ; cortezd -debug -daemon ; sleep 2 ; cortez-cli getinfo```
