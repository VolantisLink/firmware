modprobe libcomposite

mkdir /cfg
mount none /cfg -t configfs

mkdir /cfg/usb_gadget/g1
cd /cfg/usb_gadget/g1

mkdir -p configs/c.1

mkdir -p functions/ffs.mtp
# Uncomment / Change the follow line to enable another usb gadget function
#mkdir functions/acm.usb0

mkdir -p strings/0x409
mkdir -p configs/c.1/strings/0x409

echo 0x0100 > idProduct
echo 0x1D6B > idVendor

echo "01234567" > strings/0x409/serialnumber
echo "Volantis System" > strings/0x409/manufacturer
echo "The Volantis Product" > strings/0x409/product

echo "Conf 1" > configs/c.1/strings/0x409/configuration
echo 120 > configs/c.1/MaxPower

ln -s functions/ffs.mtp configs/c.1
# Uncomment / Change the follow line to enable another usb gadget function
#ln -s functions/acm.usb0 configs/c.1

mkdir -p /dev/ffs-mtp
mount -t functionfs mtp /dev/ffs-mtp

ls /sys/class/udc > UDC

