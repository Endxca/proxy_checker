clear
echo "[+] proxy checker by ender v1.2"
read -p "proxy file : " proxy_file
OLDIFS=$IFS
works=()
nope=()
echo "[*] Testing proxys..."
while IFS=$' \t\r\n' read -r line; do
        test=$(timeout 2 curl -x socks5://"$line" http://1.1.1.1)
        if [ "${#test}" -gt 0 ] ; then
                works+=("$line")
        else
                nope+=("$line")
        fi
done < $proxy_file
IFS=$OLDIFS
clear
echo "[+]${#works[@]} Proxy are working and ${#nope[@]} are Not"
echo "[*] Writing all proxy to a file..."
for i in "${works[@]}" ; do
echo "$i" >> working_proxy.txt
done
for j in "${nope[@]}" ; do
echo "$j" >> not_proxy.txt
done
echo "[+] All done, goodbye :)"
