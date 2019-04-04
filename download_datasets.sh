
echo "Downloading Bruce & Tsotsos Dataset Images and Masks"
wget -O images.zip --no-check-certificate --content-disposition https://owncloud.cvc.uab.es/owncloud/index.php/s/pn75j5TBq6BVk2w/download
unzip images.zip
mv images input_toronto
rm images.zip
wget -O mmaps.zip --no-check-certificate --content-disposition https://owncloud.cvc.uab.es/owncloud/index.php/s/C9v2FgM3nLUnEQF/download
unzip mmaps.zip
mv mmaps input_toronto/masks
rm mmaps.zip
mkdir output_toronto

echo "Downloading Kootstra's Dataset Images"
wget -O images.zip --no-check-certificate --content-disposition https://owncloud.cvc.uab.es/owncloud/index.php/s/wuo9krKXNC0YxRx/download
unzip images.zip
mv images input_kth
rm images.zip
mkdir output_kth

echo "Downloading Borji's CAT2000-Pattern Dataset Images"
wget -O images.zip --no-check-certificate --content-disposition https://owncloud.cvc.uab.es/owncloud/index.php/s/MLb0aF4yWdazB2k/download
unzip images.zip
mv images input_cat2000p
rm images.zip
mkdir output_cat2000p

echo "Downloading Berga et al.'s SID4VAM Dataset Images and Masks"
wget -O images.zip --no-check-certificate --content-disposition https://owncloud.cvc.uab.es/owncloud/index.php/s/Y9t8Tz2a0FnyQ0S/download
unzip images.zip
mv images input_sid4vam
rm images.zip
wget -O mmaps.zip --no-check-certificate --content-disposition https://owncloud.cvc.uab.es/owncloud/index.php/s/rQ5Ph9v0JfdgKGG/download
unzip mmaps.zip
mv mmaps input_sid4vam/masks
rm mmaps.zip
mkdir output_sid4vam


