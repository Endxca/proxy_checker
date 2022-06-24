echo "[+] proxy checker by ender v1.2"
clear
read -p "proxy file : " proxy_file
OLDIFS=$IFS
echo "[*] Testing proxys..."
proxys=()
doit(){
        prox=$1
        test=$(curl -x "$prox" http://1.1.1.1 --silent --max-time 2)
        if [ "${#test}" -gt 0 ] ; then
                echo "works : $prox"
        else
                nope+=("$prox")
                echo "nope : $prox"
        fi
}
export -f doit

while IFS=$' \t\r\n' read -r line; do
proxys+=("$line")
done < $proxy_file
IFS=$'\n' read -r -d '' -a array < <(parallel -j 100 -k doit ::: "${proxys[@]}" && printf '\0')
IFS=$OLDIFS
clear
works=()
nope=()
for  i in "${array[@]}" ; do
        if grep -q "works :" <<< "$i" ; then
                j="${i//works : /}"
                works+=("$j")
        else
                j="${i//nope : /}"
                nope+=("$j")
        fi
done

echo "[+]${#works[@]} Proxy are working and ${#nope[@]} are Not"
echo "[*] Writing all proxy to a file..."
for i in "${works[@]}" ; do
echo "$i" >> working_proxy.txt
done
for j in "${nope[@]}" ; do
echo "$j" >> not_proxy.txt
done
echo "[+] All done, goodbye :)"
