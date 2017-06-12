ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1-unstable.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1-unstable.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data-unstable"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# Start all composer
docker-compose -p composer -f docker-compose-playground-unstable.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.hfc-key-store
tar -cv * | docker exec -i composer tar x -C /home/composer/.hfc-key-store

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

# Open the playground in a web browser.
case "$(uname)" in
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start"

# removing instalation image
rm "${DIR}"/install-hlfv1-unstable.sh

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� Ϸ>Y �<K���u��~f��zVF���Y�j&��^5?�vOfa��>�����dLQ%�E�IJ�4cs�Ň�O9��%9�!@n��9�%AN�\rR$�jI������^=�[Tի�^U�룶&������(�+�kh#���%��;*��$�H$�|R�0��� 
ӷ� �˂A��x4I��-H^���`�{i@x�2ıl��w^�o)��aʚ��0�1�%d� �\'�}��|S-QV��B�hQ�V�C���zS
jw�A�/����J�mtͰL�6��0F��}��C��c���!R�c$.'�s%����e��>�|^����~,��$w+ohYA������2d�T�s:��Op>[�h#S2d�a� �N�n8�v���,�8�<�NWд**%K3\,���b ��^G
`���"lJW�iM����v H���du��
�)�h#��}�V�>�+�F���5ti� �T��(&�ڼZ+{~J�'�t���_NaM=wprF�J�����e�X.ItE
�F��:m��2�J�p��%���I^4Dc��g4n�M�./u5����Z�GpV�J���ژ�,*��O�=�]�st�6Cp�"�֌��rڨ#���cA����U��b��nO�Հ7ʁ6��x�<� ��ϊ�,����"�	ނ�7.������o!�hk��(J��w�޵x��>s�q�t�?Fh�:%���n�}B�d�h�f�{�eJ)��n���h���(PT��@Cm�p!��HUe�{��`�g'����% y���GmW��n���c w�3��2O���O�B�>�T��ERO�����1��|�>�?�VXB)���=��.eБ1sz���̝>�{���1���5��%��+g�ԖG�͒M(��F��b�<w��'Bϱ��tu���k�:�eG�%�=	�p;���R���葪Y���nH{=���N���}fM�4U����4�stz�*�r�#�S�x,Eۨ}��9� &Wɖ�ȑ���ǩ����|)�ԟW�h"h"�;@�'K=��)>����h>}�*(| ��F���#�����a�愦*�Ug������+�,��V尼��,R�u�]�za�@��ɓ�5�Doh��n�����D����%��T�;��lᵰ!�;J��u�Ή�$E{�?a:�B��E"dh�o�㿩�	a_�Jm��-�ې㾜��E)W)r�3�0��<����O���:��֍�V��?��o�\���!:���������5��_������7[��f���_4�7�p��)r=����[��	x�����ŧW �������@@7PG�8�0�W~Lx!�W��:ׇ�/H���*�|�:����������6��a������q��S!:������̀�GGc�h�s��ۙ�7��f8�<��6��ch
���Lb�۠�C{$Y�1W�ʩt�E�+���?��	͛����wu�����_.!�z��n�f�����܋*_,�sٝɫ�-����
�M8RMd}E��Q-�?q���O�'� RLt6ML��
|x�
��T���Tf�����*峥^A�$;��L�'�m>>Յ��O���gO�@O��32��|�{�	|������O�}����b;��X:S�}��,(Bu4l!�?@?q�� �u�䜎��
�|XY���y*m�u��(�U-�s����6^��q��?Q2ٞ��	8�]w--8/�?������(j;�7���l
�7��Hxm��p���7k�x'
k*���iAd���guށ��P���.p"p �_��-v��	b����r���LNMrO��nς��8���.�y2����^����8�*�s�=a�\����)|��G���ڿ�l��&�+��k�}~4?h�]��"Zh�C��;����|:���#͵ڹʰ?�E^DBj��%�����I�UIH_�����U8j#��nmjy��_����)|��G�������M�o������)�Ɯ�B�7���"�{~Kp!dG.Gȥ�Ɋ&�N~���ga������{�'���Z�g[���rÏ�����F�qe��%��JB.��_}S����Hh=��Qj��{#��o6����^��H����c[�k�빈�A�V0�������7�&�{H]�iq�c1��a�6G�k������[7��[	߼h�
�
B���X:����&λZ�L�{u�E�	��"����"����	..�:�J K"Vo���kM�ڮ5q�9��9sg��:W���2�:a��®x�����{+=t���I��M���^���s��.(<V��]bw��~׼��_��x\~��������M����p/����Cg���"�����m��	 �>/A��[w߽�����?��1ß��Eu�(";{�=qO�Z�`���X+,����"�I�C�H�
IQJ
IA	7!oKȰ|����?�������tJ�������|���S߯3��8az��?��{9��������0�*������|�y��c�_����+��v��O�����t"�1e�-B:�J}�c�r���,�㘝��u��L��$���D��l:�P��>l�����޴9c�TO�
e��i[(�l��knYw���Ԅb�滍x�P��8c��aQ���i9x�
q�)�B��%KBh���I��?�|�!�����X���!;�p��8�"�t�I�Fӝ��&�MK�ZR;hg�f�5*s���� )J�j'q4}^HT�j0V�W��q?ۼͳ�]HL�e:1�)�n��E2ǲ>�U��h|&�����C��X�D��PؘK$m+2�țp��h�>���1d��
�.p�z7^*���4��׻d"�4�!�_�ڙ��Q�im0k�;j7�ͅ��L�D7k4p���j��#��p�߈g�8�5�W�l��V����s��˔�Ҵ9Oi��"s8��N��t�B�8S�N��S���󇸿W�؞�U��1E���bJen�����k�H��D��xuR9^�u2��01j�ʬA�&�8S��2GcmLV�X5��P�,ko�(p5�̠�MN�3f&�y�)��xB�eS\6�ҢLH6&܌9�5ʀQ�e�(�|����m=ިM��po�*=�ذ�[��m�ܨ��E���fu�Ύ��h�e�<ɖ�m",��36lDe�خt��s�B�e������v�c�b�$�G]�։F�.5�)��5���X��փ �z�^����=;k�Ș�JJ�p�~%�gyܪ�{��,Z�i��Q1�^fr�8�T!�窱ذ�k
�F��6x癉3y9U<�2.)��$�c �nAf96[R%9Q��r��(�A.��u��N���#ִ���3���<�W��M1q�gdV���8�$.5�PC��M�f[��E�G�1�3�Ƥ�h�t@jV�Z�8��v"�q}E'j�h�XS�TS�����\ۊ;6�Z�����Ď=lZJV�����X+yo&��ę����xփN\"8I�SEY/'i��p�!s{��Ҳ��VS�j��<��Q}'X`��j"ص����
&1R��^�O�4_�*	@��y�Da6*�b3OT�ٸ�,�15���)Ϻ���;w���geF�"1N��L�"��9
6u.Ӫ���a2�G�C1&�aF���
zQj����Nq�e�B+{X㴚�*��Dc�$��*����|e9�K;��4�M4��#��h`6��فD�Y��vl.X�$5�W�7k��:iǫ|��W{�[;��H��F��JS�v������0E��u%��Z�2� D
U��*�Sʲ���{������'�bd���1JjM��*f,F��dJ+��á�c(WY��N�>J��	{@�F&���TeXhV�Z'GG���D����z�%�IY&�e�ze�_@YR���
�9hK�`"AGE��fzS*��ѹ�hf+�Z,LD�"B*S���=�g�T];8�X�Y���Q�橴2f���/�,|/'+�i�	���r�d!OKM�@�R�5��3���!³H��!O�n���=-v=*8��V��,-T(����v�q�rshH�T#�Z?4�%˹��LR�,��G���ſ�ٶ9�6g�X�v�]���<����B��{�����|w}�}��Ϸnߺ���˯ҋF!0�}���Km��>Xns�[ˬ�ȹJp	Vw?�eEK�9?O��,߇���;t���?����|j�,M}?�}��H�-FQ�»??�5�"2-Cv��L��%V��p	R͑Y���w��.x��m���Ҕ�����;���/��%��_�E7��������o����;o-p>�g��ݪ��mWr�������_L��Ű-p��8ǳx�/��0����c��߿����W2}��ݥ0�*�4#������ ����~�g��g��_D�gz+/�w���w|�u����`�Rpᗂ�:7t���-�CwAP��/�Ǳ��UU~|:(�xY���ٮP0m�y�.���ʌ/���Q+d
t�kM��z����������ЉQ�oNA���l����\OX�#�o��<�e.�*�pΆ� ^�B\�*�?gR�j�x9���8l/ʰ��p�Lc9�8�
��ƲXK��=����bY��!!��YfGLꉰ�z,)�?{��Jv���FQ����D��A�H1����p��ˮ�]~�!j����e�l��%H� �R��R����@��
h$��6���j��/�t�k�绺�u�NU�:������.;ų��ĝT�^�$*�h��m���d#�7�TУ�l���<�6�Vӎ^�ڕo��l��?�<��\fYr�+y���̭kc�y�*���Ħ����Z]���D�12��C�B��ԂQ��b4�Q&Y&J��Rix�)��$=X��޴9M"�>��H��v�E�Y������,�*��ţ	tTBq��Eʌ3���hA֤��a�q��Tܜb�wv��A� �t�{�X�JJ���W=��v�˷}yh-��ޱ��x���>8����ݝ�x����+�w#aa�JX�;����1���n	D����K�C���qD�T%#��:�HOg�6Cjs�����Ƒ��b��緲r�3��E�=���&=�(���2��fk�g�v�Cei�n���!�Qo�b���0��|w���m�3�>�#,����	�fI�!	�%k�i�N#&�mO�|>�d8W�tфҐ��1�-:�re��z	�
ө�4b-��3�21��	�HETFR�����o_�D���QحԚc,֠��Ev3�6m�\[���M��YA��7��F�.��CLZ���x����G������bl:��9�ծFܓHX�s����:�Q��o�{�P�-���� �׃Lr0���
zwi���&k�2<?M��d����������E�3���8��ڗ�/n�zg�P�۰�Oh����ނ~6/sI=�A�A���;��%�>�p�3g�ۊ����g׏��?�����B��ӏ������?��߿�~�sN��זEuuxj7�}��9vm{�p^����_��w����__�M����������W�V��������=���?L~��?������A����?OB�KB��h�ݷ>���[��}�_u�7�V�e��w���$���k������o�O�Ϝ4?��?����[�8q�/���q����g��v��v�N��	��� p���a��i`������v��lap�<��2@�o�T�7P�����}ASZ�tξz�C���'p}2{�;�n����9��7�>�qM���3 b�3 S�`*���:����#��� �����;�ln����`mkf�� �, ���t� ��<b��#���2�Om�;´�P���u}BgΧ�/��[��V B���?�"�����?Q��W�)�p�;��`�����x��_��} A~h�s���r���o�����w�Xn�ן�Fv��P�b��MPk���Ӫ�� 8���릸����\=�}�	�	������/Ν������X�>�y����q��R_���*N5�����ʿ�����1��=�`4��뚎��(������Z����[:�"K�$�"L�E,�4Y�fI��.��%Z���b�����F����Nz�N����|0��}��o-��A���`]�/���^o�p��o��Z���a�ޑ۱��ě��4�;�?��m�s���r�1)%��eR��'�9)���^��5���W�T����n�KU�7��mx���o�lZ���x��o�&N�M��?�A������B2����oՖ;�ޑ2�SJ�(����ow���`�S�=��g툦w?l���|Z.�.\��o��(m�{����)���9*5����ˬ�����y�Fktqۃ1ܰڸ	;#nx����rCw۫�-�ힼƄ�4�	o"�v�M�K���W���Its�wr}������vY�7����=�p��M����I���))!-J�RE�i���K �iSR��Ɠ����%��3b&��
o&�������6�G��Z0z��v���k�^׾���K�cӹ��`�'_�L��Ku�D�Y!��*�W�o�?��������L�bI��z�m�ؐ�&����0�,�\�Kn��Λn'��4]�L�~�ND���t��ĳ��r�y�'��+�-!,�۵]������h�/���a��nd��=r���}������ͱO3皳L��m��x<p���F���I������������-�����r:_X�!�/��\B�zΛ�pi��6�?%����rS��_y�?�j��e	���C&D�����?��ƍ�^{�߉?=}�!l]��}�m|�Y��0f�p.=	}�q[)jͦ��l��t��MZ6���v�}��z�S@���S�N���b��N7'Vrک3�h��~�<����D��
������8��q�(P�A���K�W�8��Q�@�����������=
 �^ï��v��l��	��h���-���/���^[@P�B<�O>S~�����m��Jw���(������Z������4B ���9����;���#a����������N��4B�X��0��(��P��Q�b�$���"e"d�DM�"L��E�(���y�<Wc}a��o��E�D��;��$A�s�kw��T]���u��J�� ��iF�%��J¼j+#<kM�(;�w�R
fT?)��������Ŭ�mpR�U�
�݄�J��)����2�J�c'��F�9>b�r�9�"�BcVT��(ږL�:��(�wSfO�Rt�h��웝�/�|Ʃ:�����������?;�/]�}w��	���^��������i��A�d�����%�2�%p��)��5D� Q3n��q�� ��4z��c@����6p@������0�?����	쿁�T��w� N�P����?�� p��/��i�{W��S�l�rb��g��@��9]|�;�c�G���O�����^e��g]��ю+�Uy]h����e��l9t�t���r�`�\K��犍����Ê����-�Z�fՕF�� .[��w�swu~A�87��]�慬��\K�s'F(V�3V��h硴�gܙϖ�l��� J����F#�\��qJ#N-z1�HM��i̢)4>�k� �EiI���c"ϩ�c�L'��!2��w�����Hv�*[h��:%����������R7�`�'+��������l�/����H� �N��`�?,����O0������˵�A��?N� �?�����_��
��?N�`��� ��?5����É��4)��I#��X�n��z�AS�E ,bѸ�`:[�0ʴt��P���i��O��A����B"#�d6j��F%�b��$�����E��-t�O��|qk���R�r�D�j�ZLȥ�0eܾя���`RFÉ��:&��hZ�Bs��u
4�Ǉ?3ǉ��YTe�X�I_�Z��������� �G� ���=����A����d�\�B����� �?���� ����/���a��_����?N�S���y`8B����'�������]��$L���L{�s��~���b�����u�ϖX��V��z[r���7�u�)�U�<���#�4#@̠ɴ��j�c���L���T���C�(��9ڭ�Ʉ5ڊP�r�B�g�6'G)��p������0ac~x.�T볌��K���k���W߻<箢s�U�Eٿ$rˋ�U���Dn���R\�ZA�Ꙅ[o4ى�}��ʬBB%���B����N�[���M#�p"�Z׋��dA
�r)қw�n����q2��Y6���j��MW������Rj$֥(�H��[Q��5�D,�E��@�*T��x}�:� ����C����6 ��e�a���t8����� �?��?��?����/��|��k5�x��h��A �?��r:<k�b~�D�?B��0��A ��@���˕�� �a������������u\�t��`�E�D�`h��,�20����qaX%a�,b!�ɢ4K���|<;���{俛���e ��#���FZ��aJ��Z��e�4מh5���8����K����@	$_o�v2B�#�\��޴ik}�6�`�!"ٚ�s��TM�Ӣ�)�%(��Ң�!1���q�l�͊Q2Ju�٬�<����#�]����8����8������������?���� �߫x��Dx���>.!E�<�������#�OS���D��wN��v! ����������'���������G�? �g@��4B��b��b����:�Q,���:���f`�A#�뺅[8K0�U75�aML?A��q����@p��oə��5�Jhc�
Ҁ�#�6�q�=s����ǈ�������a�&t�����!_gs9��Ghn$�IF�;�X[\h��rOYd�z�jB0b�8Q��q��8�S���-0���r`��������_$�
'��v'��^��
��I��D��\��D�?� ���������J��a��+�%�P��t��,���\�4�)�`�vMY��[kKI�U�,���"*�\~��.;��J�EUYWjlU��z/��{�9�ZYřQ���B%�W�RbT��ͽss��oϩ��LXp�Ջ���
jNu��R6Erb�<�z���6�\Սr�k�䢅j�h���f���Xj
�d-���UΤ��+�2�fj�+���I��m����A"s��V�4lw W��^�����n+��q3լ��\�X7��xj
O��ܧ�L�(R\kZ����,�
�)p�F�RXň�v�DrZu�|m$����s�j���SWiޙ��B'-W�5�-^�S��ފ�d�VP,;�;錼�D.MVHr����;�����:@�̉�ĵx��Ђ6��� �)4���ir�9._�;%�S��0�6�4�9gA�<S��(ie�n�&3C�����_Fr�#׺j,Z|y��B!���_'�I�?������-�������?`���o�
� A ��A�������a�_���/��a����Y���U��/���<��VQ���m@ݳ@�@0�S�z��b�j�"�m�&]3[l?�� ��!�is�GdtnG�h���{�I��b�^�ލ�qY!�Il�;�gvgg����e;���=��w7XKuuuuuWW�TU?W�HR�x( �?��HćE��"� ?��l)"E��#$�#po�c���=ZϮp��j��=�Q�s�sν7<���R���A6��r�LJ�Yn���T�oFZ^�<Fۧ�X6��<�B�I�f��+5-�Ң���^��}��}������>�����ԛ�n��3C.�{ʹ���Ŏ�;�4��K�A\L3l�U�	������0�'�Q�.�tz�̊��H����{�hz(�?�	��������g_���������
�O����>��R�C!�m��K�����`�����������������O�I���/#=�?�=�a�.)]����C�.c����)����/%���������W��?m�����%��t��^��t�_���Ӽ�+�\�S�)_�lR^�rRI��M��iR����^��(���2]������t��������>�q��<(E��6���J����KR�g���!˃蠛�<�S��(���&٦+���Ǜ�LO CL���!��B%*���>��� R�wx�s�m�x
ٸ�"}�J>�K�]R���\4������Bp*2�ڔda�h���9�?�C���*����KH���K
Q� ���C��UoJ�a₮��-\�%��9Y��*�唆�����> z�ӛ����%�����`O�ʌ�n.����^G�MN ��z��᳦�{M�Ӧ@�Ӑt|O[�K�s&���x8��Xq��J�ۆ��; ��a�4��*�&�3�6,�i+�;�����ƿJ��srK5�W�N�Ӂߵ@ߚ��sV����gݠ[�����̟, ]8�	�Y�%�t;����*P�9��[�׳n���~������yD/��������#�4����,��;����u-B%HEI�3�������IfA�Z}PN�PR�jGX,$a!� i�o��#)D���)w&*gt��8��2���Tu�l	�b��%{�>���%�&��ڵ���S�ƅ�i]���"�m�.#�5��v�Ͽ�>{�/#]`�'�~�ҸZ�}�����l��2�p�a�|O́�w��������h�*ZP"9�qաp�eqv�r-�Rcy�E�g+=�3o��L�0��o,@K�8j5��.\�w�Y�ߤ`��5�=�g���\��7�+�q6��(�sT��4I��	|?�o��n]����|�/w\����7�d��u�Φ�����9�M��r��nN�����{�M$�}�I�^��y��i��c��]�����O��:��\3�{����ʯ��뷿�/?�}���^�[_c�?w�'������ LB������� >��}������T�������`��I�� ������on0�����9�b->�,��d;>H:���g��ym���!�0t���K���|��rz@�����Q'\�T���v�D,8�G\.�[����8˗�l�L��5uP��<9~XjF��NFJ�q���ۥv`������I���xA&_sv�{��K\��?�0���j�I���!s�B20�>>�V����θ��[C�\a4���LEtFRr�FK�Bi���N��R`\�41.��S�"!������,ǕB���f��F���v5�2!B����þy���۞p���'���B�=S��\���$l�����kJWH���L@܄�� ���Hփf�'�<'�r�V��� `�MƙH��i�n���N���H�n��KeT��Dӫtb� z2i�ÑB�.�� ���$k$;�esd��!�
 ���s>�R�1�zx	v*X�1�����DdD�&Dz��Q5-��+R���F�O���$��Hah������P��}����d=�(ղ�gW;�������%��}"��
�r�������U�C^gU0y]�O䲥�H��� U�fy%.z�q�#�a#T
�*��e��rr�e�5m��:��0Y9Y2*2M�˙&`�ɤ'[b�9F,G��`O%��N3!OeH�<�H���R�T���g/St8�M��"�ѸY)�c5��MG%/Y�fk�A��vy�֐ojAF|��?�X�'��lbi�@,1*>�,�4����SlkDR��+-��F�X/�܄W�	�ǆϯ�-VQ�fjܨ5�D�?�\a2.w�PS���%�JKr|eܔ �f3�\��g�c�rx	�TbɆv	����.�bU��`TH*^��b�]H��E.�"�
�Y?��C���fP.y�r����t��E�Q�E�+�N�,bq�:����:�j:���m8(�DY�LA7�셍G�-l��>�񉭧�O-~J�+�`����p���:��S�u6Y�*'p����z	|*��|9�Ԟ�=�=w��]c�2x*�|h��dTY�Gس�3�i���ddy���"x68�)���%ˣk`]=�9�b��H�M�
x�Peu� W��䥱�}��6�~���������#�:���'10�����&x: �|���R�9��I|u>���6��f,��f�v�o��1�q1���W��aȰb�a��`[$P���g�{s`� �#��s�+��3����9B������M�Ǜؿo�k��(�?
V�(x�ܥ{r�Xz~�XR��v����AI	��±����~�؜���ѡc��dѰ���r�+`�ǪG�)���F,McqX��}��%�H	�p�N�A�7fw�ΰq�4�|QN����?���wTd,DF�0��#�[L�~��%[-Q%�ܦ�ɴ�W=��8�H2�Eʡ	? 9��LL��1р�C��t6f�I2֒=`g����)I6|z �1�;���}Mg[I�}ɬT�d;�^���R��S�4^m�V4��2\�&��;����:����S=�0dq1���K�%��T�[�����]Ԏ�K�Q��q&s8l氙�f�s�X�=-�e�P��̂ry�CS�d��LgZ�9�춱�!�s�Į�+��yg��\˵��7f����q���˶����������#\�n��Z���t6������!�|�#��%�<:U*��na��"3���Qd6*01�,k�����a���]��1$�w������P$ ��t�![f��u��'��C�G�L��9Y�5�!:!�u�=FU���h4�Ĉ\5#�l\�ʋƐ����1�-$X��K(���O�J\�+�1��'z��E2�L��&I	ڐ:�hW�ĠRk����aKæ[�4���ʵq�I�)�b^"�d�@-뇮�Xj�d�(:��E�֮��^?�8�v5"�y�����6s|ܘc-�ǵl�[I)s���-�X����In3��x�2ۅ8��qFKRļ��x��[������ͩE�i4t�0b�i��4��i�N��_��FYT�+���m�+��r{�Ap%��|̎����1�Q�s5w�#�~����@���?C&������x����w~�:v]��Y�������촜.�iTU��)Q�����ǹ����o����?/%���o�㟾����k�7��=s��ĳo�ֳ����-���?{�1���	�	��m<����_[���P�8��$Ej`[��%~�/���/u�^���:�����7���Y������Bh�w؇ˡ�?�C;��N;������Nۋ��{qm��m��C;��N;����l��a�\;���Ao�T�J�\"��r,h��
�ٓBg�C`�}��������8����`,�&���q�Zg�خTەj���a3��3�@���.#�a�|}����4M��3c[[�=3�� {[��g�f�9.a����^`�e�̹y��pk��V��h�G�c0���/�#h|b��N}�@�g[������B"ώ�$I��<v���m�^F"n�&��xA1��S �[��3��?Ӓ[x	�������w�cZ��jb���.7���{� ې�:�^"�K�u��,�3���V?�V�Q�ij�� 8�B�����8gBP==;x0�s�`�U]$�	�A$��p*ރ�V(*2�8:�W����G87q���0en��:Ή� �Lx %۷pCm�NP3	9��=s	_����^������xށ�|<5R�b�b/3��*��y<�Ã�T(^��S�WgRU���B�pb�#5�0�aJ�B�B[^��0�X��^jJ<|5E�q���*�p��	zW2Ќp�Ԍ,u%sr����B l����̶_@�d���q�՝m�{�*�88�e����i,�4��þM��vt��B�4�X�[M~��Dd�%�9� �8
J��@��UAz��5�B��}v�)д�U�M� n�0���-j�n���'˓���m�������s:�ȺfN�s�ŷ�\�1�ɩL�����xge�*��&�3a��l/.�!��,��h��C����~��/���������ỳm���o��MN6ؠ��w&ޘ^?���5A�$�2;����Pvn߆��"��C�N�7-����$�`B����>|/H�b	�x�� �=�	��W����8��(Nh���r;����|�w'�����<�f �'���'���ܭ9 nZ�z��ܠ�oj��u�;�2�����[�:�<�����B� �E�,�o��	NP{S���z�D �؇N��v��剴��CU]�(w�l8��<�"�
�a�����ӫ��>�T��:��qk�b��-D!�v�31%u���0��
%ؙ�`
y��������Ff"���̷����sho���R����Mc������͉#K�g~�bzw�� 	�{���1�6��:^�c����[YU]���`��RVVeV���"�^��h1��w%v�5|��Vi�����S���srb�$@���C������D� �lj������36�;E���S�����B�| �> �d�u=����qL�x}h��5�������ԑ۞�9-ޙ��y�e)>�l�����&��]�sA��$�_��򴼑�W���-8d�'�]���ρ����d���YP���n�믿8>��} ,�^x�$.�����n�`z!�Z��Tq����x�܇��`���- ���z�N���Hҋ/�ė; ��JXQ�#k�����y'��a�u���lY3�Q���m��o�H�6�����U�椁?65���vW�P��A�|����.������E�����3��Ic?�$׭ݞ�ȟ���,�`�<���P }E���hO5p����[p�ȶL�p���1�kg'@�ǁ�-��u���)\�"�'ћ�o�[9
v�]�f�Y�q�;��IX|����e3���"!#|w^$�2�(2�;Ci�2h��E��{�)}���^p���7�[�En���gҙ(� ����E�b�mͰ~�����YXQ��V�1z
 �Ե���1�qt>��ʵ�s�;E����~���\�A����������[�ig�1�\�1M���"i�/!�4�n>+�t�
i���a�V<��A��a�K�~{��z����@P����"*@���Q�x9^��
�����`�F%�
�(�S=qkiL�!/�}�NX�H�S�a�2#tG�J�Y�e��?�I�7��Y��1~'��K9)����c��e�ߟ���&�{`��:zU�@)�>�PCMo��|<�,��:�!O����^�Z�iס�O�NEn��4Y=��PZwW�ދ�D�{�?Ґ�_u��"�?x��%����I|�|]
I�mh(�X`�ᕣ*�&}�M���dwR��8I]�	<9�;��8l��R͂�3B|�4)�\u�#���v��5��K�����G�>	�_�[�s�A�����P�F�2�P��kRvg������%̛1���ŭɡ&S�S��%���A1)�@�̬��$���4k
�`���{�� �n����~ΐ�X��/(��t<ru�P?�;��9Ɨ��?�јTܾ��3-U1!e�$�O���삫DF����2��+���B��~6N,R��:��e�fԝpm��~��O����)<�=@��S?�'�Jnz�.�	�x��Dp;���jT�sH�#/!]-!w�^���&��i��p)�e"M��m8HU'r5�D�O�)K���Lϟ)w0D�?]
I��/w|K���$�N�������Wq� �(t������Q�
mIk+˦�<)�7��}��"I�����F���)ȳ`K�p@��#�b�8¯/�Z�*���ًu%���K���/���ܤ���X5��6i�����	����j���×C�	.DX?Ā	��KzBI��	�N������e>�? 1�x�w�I��_$�U��
��y�Rtd1��P�e=[�L�tF���)Ż�+"�KH��_:�?!�mY�H8z��4�,��nv1W�ᘡxDa�\6Z�$�`7z���!�E��r9D��Wmۆ�:(zGpN>S�X=��� ?��7c�x��AR��H)��t�{V�N�7���g8Id��=S��z�"&����d�st$��U�ٻ	U?�ٕ�p���/�;�$KY�$���T���H7�a�*�̐��U�x@A
�dp�� �����N��� iH��ݭ{akp�_�&=4��d��q/�aد�g�V2�w#s�xN�@�exК�N�6?�u%��6��IR}���4������ic��6t^�|J�#Z~���G�8K�^�-^�#�[����	HJ�N��x���	H!�[(��xC��8r�yr����;�?)˧����$��_ �|�Ő@�!�F�+�dc�B#]�bW\'>�n���>�0���E�?0D#���W�Cq;�t�ɷ�	~����3:wo�팆���Q)����֗�z*�=bIw���΄S$.Lgf!��U}t�Iѧ���"�'���|�<��R�˧� 8��9�ȅ���~s�=~�u!�^��&{�~��ԁ\�C���ĉ���/E�[�Q��C�`��f����Y�416�=~HC�f*����k^�L�� ���'��Ǧa�;6e�5�����`܄��W�pν55ud��w�%���kK���R�w�ᵋV���~0v�[89��'<�#B�>qT����ę��F�1�H��;>Z V+�C2f�i��]GJ�o[�!�)�AEnuDQ�^� q$�
����)�Q�(�?!��'����!����(���,;���
�/��y��M�Z$�L��U������c�OT6�h�)Z�E4L�#�!k[�`rn^���g�q��M��H��&,)r8��gb�!ճR������OդfS�� ��gة�HR��Z�S4����xb����į֩碐B�WVJ�2b�.~O��I%�`>���?�r3af����P�1@�)ClN��ڊ� �M��fܕ_eӥ����]o_�U;����b�ҾS�?Y91+��~�N<r�0�!'�z�!,�r���^Y��[.�
�u�Aƚ(��ڝ�o���=G��N�a� /�^�2�Y�&%�ߋ�	z�������	��.z+��\7��y��?9���|z̻T�f'�C�Xz}�&�5�z\��a��p:��r;O�	� ���]a����r9��Pdf8�%�Έ{��,={�$O}��#ˁ6����s�Fwr|VX����)��vZ�'-C�yf�eY�Yf��!����/Y���G���rU˰7p�w�~~k�����#�[�J����߀���S��;�gۀ���I��O���B�ɣe�&��7��\�"��$0�?�@!�?���OJ��='�I�Sl���t�W0(݁�;nL� =@���X��Z9�|���4⓫9ZP"D*Ck
iF��e n� [�]x?[�GX���p*<��xϿ5�p~v����m���)���n��T����5�Y��q���2��Y��L�*��p:�� 4;�&�[|� @�(6�Lཽ��>,趴@��N�{=ܯ
�8�4�U�g&�e�}�D��W$�K����L;.�f�K�9���V� y��_N'��9ބ�]�
}��Ճ�O{�օ����C�#�<����`W�D�Ag����d[0�`j�`���XƱm�x)}1�� :=� �90\���S�C�wݾ�x��
|A\)���:�.�Pk�T���(ieh���ce4ӓX1�%�A����miT]���\'�����c�E��
��TD�ދ�ޱ� �7]��)xK���@P��e�k����)���˾��������80��j���tFd��ށ�˔�����/����'�q~ ����L��?H����=�F����ŏx�x��a^��$�d��~�Nމ����^j���Sx����r�⏸�b�8�����	L��[��sbX��������nI��� ����ߴ�sٰ��1�lL����&�i�u]OK��e!��	9��f3JZ�
�$|V5#'e󢦨����72ƿ���q������|:+��?;�+�|5�Z��e���~%w�\�zK��u���V�Z���ܹ�3�2�����>���V��%�c3wu�����I�_�-�'���'�Ui���]_�w�v�>uR����-�s��9�8{�=X��B��T��:��e=qi��F��i�]7��{��T2O��R�r�K��������5���Do)l��r����2��m������on���c��m������O,�A���8�&��p�s�a�?!���?��8�}5�}5�}59�ɛ^���6�R�!�/���8 n����X��E������m������lNb�?؜��]g9��V��BD�/��?�^�_}@�:t�����g{����t�8O�2�u^�ʽ�zú�??�8�:Q�&�NDE�?P�F�6����s�RE��i���k(���my�Y�����1��#�W��Es���F�:Wn���aa�������&�{Gՙй���.F����t���O��!KX�u����`V���I+˭�V䖶��'^[.V��r�r�oʳJ���r�(U�[�w݃��ǭV�D��aBn]�J3tK�yc�rS�g�F�P*�fuK��s��w����=��v�LK������U���Vf7�Z���

M�b&�.�z�Xz�)5�E�?_%��$}g�S�Z����Gb�mN2m�Y��Q����+y�JJ}�b�P�k��׏}��l'T�z=����a�?!������8 n��~�E�[,�����6�Q������`S�����"�g�������?���|�6�����A������-�l�o+�?;�cc��g�l0������?;�cs�1��5�\7�Čޕ���v�R���W󙜤t3|����Z^�
�$JFW�]ḀzVg��؂�/;�c����?ʍ�����U��z7��^99'�m�]j_��᳖J�����y���z�I~j�v2�w����U�������q�zo<���FM���t'g?��&�@t��(�(��Ƥq���͘�Χ�����?�
�`�������?;�c�����o��g�l6����-�-������������?l�;���q������l�o�?;�cs�9���r �������;������T)=��d^��MP\�w��/~q���O Y��Y�@�Cuvݑ;��F'�^ZM`�T���e��ߟ�ˉ��~�_�����H=�uQ�Ui�U;g������"7S��鴠?����s9��|T���e���*]�%���a�p<�|���V��*D�%E�I |7K��1�-%J��#�U���90�>�+�Mr��qE��ʕ۱zޘ���������
�l�YKU�u�ty\>�����y�<��wZ�+��ܯ���v���<��W{Å�0�{�irr,�����Hyh߶�n./z����թ]Q�5�1�k��z�Yӝ��\��L��PǏ����㇏����;�cs������.`������A���?6��������?��oX����Y�����S�k
	�^��������6�������;���o9����������8�����g��������3�Y�/xg��畬��MP�Е�����4C�
]]L4]�ji��2B�/�y��w��Qr�lVR�)�q��;�_��b����+��8��Ϊ������~}wu���g��T�������q���x>������?��V{3�d/״��NM�>�[�hv�x#��
ߺӆ3���lhO����ZM��W��������ٵ^��ѯ��@jΤ������f���oٺaU������>������uN�}=��"2��1�6��B6��v�k,����f[������?>������m��"��6��,���\�?�� 6L�3��q�/D������6���� 6L�3��i��"�?l�_,�-����s>_3݂������T�M�x]�
���]=�gҚ�u��t!��vUC)���
�o����+������{�_w��}[z�f�:��{��h�5�����ل?��dm���2��R��ޅ�XRM�dv%w����Çʳ�W:�Ѱ����F"�v=�P���'�NYv>�W�u�]�;8d<�K�	���s8B�-$E`����_uK���$�7���uu�Vk/��haZk����z��>���о�`�����<�v�+�	��t����?x�+����g������L���WJ�#�=��m�����b�����t,��x��������ϻ��8����Z����`�.�)0��y�bԾT������[��nTr��Z��X`x@k����_J���KUg�нTeM�1����9e߬b��,�Pdk>k�z�(��9<����ųZ��d>�uZ�ܶj\m��W�*�L/t>=�_��潱2�q�Y�!yevku>%���a��u1^�R���x�f��m�r2F�C�
cq]r������ �\�Z��6�#��g��)��qBc#wW��]EOP�+kTu�������Y��r�id�*e5�o޵�z����ϳw��c�sB�D>k����#���d��}}���r���3��[��ٰ-x����K�U6�(��:��r��_��*�R�o4ˏ��X��JM���93&��'>$��,3���9!}��okb�<O�>��ش:)~1g��j�Ӆ���$���SJsf@�?=Դ[�:hg�L��5'H����-�I1�_�Z�����;	�/���j����u�����m�����s����NF���� ??�����%���1�~�_�E��/7L<>��ć��C�Z��ڹǵ�/��e�(�Gk��gm���6@��`���i%��e�U.0��4ve�bэ-</��[���[�H�Zq+�����d6���c���f�H�Q�sWϽ���L����ݕn��W����gj1��������]V_��� lw�:��_v��(չ��˟{����L�B_ȋ�a���Z��,�_D��S�ʰ�o~��
�J5����N�|�������l��y��V���>����W�I�1��?����^��^��)������I������ ��Q҉��`����I�������`�?�������W������GI?_��o	�)�c����d���I������ �ߑ�Q��ݟl:��?��O����������������?������b�%�I!���c�X���N�K�W�*�NE�d�j$2b"��b�^j�NJ�M�b�׻�'�����t��_��T*��9J: �S�p[*���í|�En�|�*9����3�`*ʬ4T>�G�������vS���D���4u+�k&#� 9��?D�0���/��۩X�)Ɉd>p��ûd,�n}���U�3_{{���Y���%����$bF��LM�]�.�/�,�?A���o�tf�u�,����]�ݓ��'y�ӷŷ����2CC������2�L+����g�����(
���W$�J��ü5z�3��ɴ�\�,�[��r-M%ulb���Ԕ>��+����淂���xP:�6�-7jl�P�"�h �"L�#�c#�`=2������z��s�ҭ�M�y_�m�I���<&5%�Q7SV�ڽ�͌A&�H�Jz��'�����p_�%l����=+>ul���x*�*�3|�3��??�M�E�x��0	ȢdfA<�ݞ%RBC)�F�"E��sHD�W�n:��Q:&4A�H�T64u�1�H�0*29����"�#�%F|�:�H
�a��8ΰ��y�7�~�#Qh��k�0<����@V$��敗[>�Z؈@0����{�DKʒ��,��}2SM��%����3�o/��V-AV%��
c�
Q��( pL�rV���d��E[o�N��f���<{-(���[��5�J�sݗz��sn�+��uKl��j��(U�[���m��-��
���Q�����ƶʍ�5��]��JՇ?�i�"�Lӌ�I;E��޸���F���EP)\7��c'4X!�- #���7"hU�.�M��B_���Y��iভ�f)��(��V\�%���\nފ�k4Zy���s;*a!.���$-�=:���4u���:��e#�"�nE��.X��i���l�&=�3/��Bfz��Yl�C�O��Bf]p���#���W��7�j=��^ʓ�^�L���在M�Q��Aι��ԧ�'���V�U<S �5������@H��6A3gjHz���c��rT���j� $�u�Z ?�dE~�PQ�<X��� �*�%A���"0��֤}�q��U2����A!4�?"$k�p`���|�c��2S����~f��۪��F�u��ϒ� �x/Uꥮ-�l�]Z�Vg?��-c"-?���H+4�z�z����E�{�
FĘ���M�&%�,������hO��"s�r�$ĉ��O�z�Rj2�������-5x���68��M�pu�=���ތƒ��Lu1t[m��0�*���s語X.�5Ė�kza�4�;0<�l�MQ��\S�,��R�/���g�1p$.d�,� �@-H�,��`�B�$/�����h�Ib}�g�0TY��B#���e��B�S���o]�>__�Z.�U��|Ԯ�����ó׎,��o���BΩ�����B�b	c��N5�����!��.��$���̌��dl���YYڤ2�"�,<���-�����6����lPs�]��H���.�}�⢟KV<~�Pw�s�7�Fw�^����~t�� �B'DK����K�x�c�Ue�5T��OU�~��d�&]�Մ��h�MhB_M;UM�^ӄW��	�/Ԅ��Ԅ�V�B�Q������`Iag���۹(�c�7K�V���`��()��~CU��TS꣉
M�)�"|89����(@q:��1���uv�����X���Є�Z���*�� J��M&,}YP����p"�8Xh�����zX�#
��k�DH]�hgy6��i,�Èb���j%��y6�+��@[U$�DxsW6���9s
=h�"̀��04$�Z03d��.����`HM_6-C�M���r�����	*:cxT���
��|���`z�O�1�V��Q��P/TZ�F~SJ�p�$-	ۧ��{ ͔�HJ}2l�$-5��Dk�(d��'`K���b�n,�xFMh`�Q�lٲu�_��E����މV�=E)��F]��z�؀�֩Vh�`��¿ݼ��T���I��w���f��&z��&�	���@��jg-|{!�)�Ȅkc	����h�tE	j�ҡdUɓ�в�$��R���\74&�;��;|��[�?��1=@7��@E��@YDT4`���Fx�j�-������b
�R��(&x�md�=���a�i���U\�>�3H�i�z���v].L���i����. ���]�[�jjx�5/���N{��c����hx��a�
;� ��H��(4�����p��1����� v�[���s~�ޢ�����Mj�hphqn�e�� K�f����2 ���|r��ɹS��w�IA��4�l�,�G`�O��u"��_��K ��I���� �sU�h�g�"�-H���)O�ijL���` ��㸠-�����'〉�a�󅍈l�!NK}���R_8��G	e�V]�盦+H(��!��(8!���g��/�6-����i��|#d�e�ծz{��&pL�x4A�=O�0F�a�1���m�ߐ�F��7:���S�]�2�d���W��ɳt��g�Z̃�ppـ�������&C����'*	7�$�8�`�j�� (�n�N��_ 3@��B`6�'=PT�����ڕ�� -X�W����DQ�����@�����V���*۞)�cI�t�fd���?���]��~�l��g �r��B.�=]�s��m�)
�bK/g��{B��)�����52��&�04�A��Kxv���}&&a�S;�`�P�2s���%�e����;�oq��lՖ���ܩ�%���!iW�[�cPA���%�\��D�j
Kzpy��ԡu��i49�pB.�f��.t����e�Ap�����Ț����ŷ�y��C+��y����{-	�;�~a*������ .Y;ff�zb_�t�\8�W҈éDV�o���=���+ރQ��=�?��#�'��#P�{��L�-��cN�4�%ҙ`�������y���vl��W:h�T�^$��9ڿ�]�?�����O?
�����+ғ�HO0G�����,��X¢�\OY�&��.�46 
KS\�n�-�&��}0c��ӌ��M��dg��#����c���o9�/w�F�˳F�z:CgX�>|����pj3��*��|��5,4��#�����D�K4E��-x:���Z>���g�f����;���$(��ɀ]��Y��O&bA����������M0H��h	C��Ш����	A�%{��vX��;�;���t�UH�嶜�U��3�� ��$��2�G�l��G2����t���K�/v9�&��đ4���;���=��\7�ܐ���v��E@��nI�c��� �o�vJ��ΒwX74���0�M��V�#��:��p;.�HWQT$A=�&9���p`���5�?���%�?��Ug;�o���:м
������R3&P��Df������ۯ�<�i�������9�H&:����K2�G>�^t�<	`�*b+Hسf��HR]��N�b�.Ah���4,�^�b�V�=���7<�N�=����đ�~���D�Ż��9Y�vl�~����񄐉�{�W�����*������ڭ	v��t2�z�'�	��%}��?Ĩ���Ǭq����PpPQ�{|�"��iG���~���"�c�V�8�������6��������K+���� E��V�XD����xA��C�:[�z�1��o��ӫ�� Ҳ��WC�Rҥ[4Lԓ@'��c��ק���*Jg?S�'��t�;����������A��c������?���D|����?��N��[�#e�Q����̱�����͟_�X�����&R�����Nu�w}�d3�o^��\�^��i�LԾ��l�Di0��R���m��[�r��?��p��}���?��%�*��t��8rc�����r��~�Mr��u�f/�������f���t�-��<�3�>L�,(& ���!��P�iW��dzu�/����?BKxy�4�"�ֺ9��3�t8�B��|!�s�x��OL\���r,�s�$( ������zt{�ȅ^�ٱ�B�'�m{�8~�>��w���s�i����=���I�!aGh���	0"k��7�.������(�_��a�U~x�ͷ�J���a�kT��,��+]Z���ۺ��:����&z�Њ��/&|��VB�[S���w��,/�L��J�LQ���k3�L����h���=�?��+�?�쿣��_�q���=F�B�b�oX9?��#[�(�Md���7���l߰0�n���l���!UD��
�v�4��g��Y�PW���/+��^�~[�����c�B�����il������-K%��#��"m_`��'|��?XV�[�����ػ�XǱ�ޙ�����l���^DY��βW3�G�$�{�'q�ğ���؎���p'qb	i��*UZ
�>BW����R�E<T �XZ�P�	�x�HH+������;wvgg�r�por����������w������g��^��#�6���?̑���rr�'rj��O9�<X�*]o�l�ڿG"ĉ�sdv�3+J3�I�I��������M��CϐH ��dH�p_w���i��5���t��~�?�X�$�(��%����J�� u�R�=�+�>����'�1$A�����)9�DJ7�dx�)�Ux�5�U�S*�I��Ni�-�Z~�&)8l�x���nҘҪȜM��d��5�f��n���-l]�`^L��D�*=9a�E��)A��+�B��̓�[�9C�s�[7�=%c��
�?��}��'v��+�f����鹽:Ak�ww��Ķ]��[���z�Ր�Y?qfo��VPz{ͮ�� �m[�D3w|��r�9~��UZzˍ�uz;{9Q���MM�T��=��aW�_+�!�v��y��X�?yw�?���r�cX��8�]���H.���s��wy���������W�Y�Wмc�N� l'��'��c���3I��H���l(nwL�":6b���wp�$�d>?=�n7?�{��~�D)�ˏ�������J�>��?�����7/C�q�v
���������)���U������d�]}�O�K:��d2�f�Ga�����ޖ�����N6�ػt��=�CO�t���?��}�~9�{�1�B�?_K*��u�c�O�m
^ڴp�÷��iS������?~�ߞ��ۗ�x�?_�}�@����_	=whNgg��x�GG	���	�p}��C�{�?FdQ��g���?�:���+/����3�o|��� ��/_���̛���?�V�����*W���Aoi����K�/%X�7��Xq5��V��~��ĭ�� �m[x�(��6�1s3k:�,��-����%s6�0Բ�\w���m�J$�9M����o���?�Ư?����o_���o��m�;�[��M��VXB����p)��������o�����c��_y~�����V~���s�w��ڜ�\.�
C��!]�)��eP�#%�E}wZ
��9>�vD�F�Z��G؄6��
	��Tc��@뺰`c S��'-�tO�Z\`ᕙ�`Eh�:[e��Σ8�g֏,��T�\*�������ݮդB����+�DQ�k��jG"S^
j9|k�e��,:.��0�%��%�c���Ŭ*$�>M	��C�њ�bd�lC���#/QÊ3�̶�F��ͦ�[1�({}sW��g

�w������@�[�,	�3�	�\�5\������i��U�<�N����%z��ն[�FLQv#wPRfUs)�\Y����Ż<Xb�:��i��8,���a=���B�#S��J�M��f"��DR�Ω�Z���e} Q��~��e��d�;��WD�@�N��T� ���޺AW�(���f5��NTǐv(vZ�owc/$y�jf�c�Lz����q����� W,�*��|ՠ̂�DO״�[�(�U/W(�P�ˡ*3~%ȳt���q�q�� ���h�
{F�!p��-Q���Ω��=w�����?~���T�d~-UQRy螑 6fe�׌Ee���vo�����?��^$�l��a�=Y�U�و�V,�0�A���TS�b��E|����6���T��Tk�ַ�t�j�~5�,�*J�F��D�^��in؋\!���x���E�����/B�D��OiU^�tv�Ee)S�@J1�:�Q���R<�dTn�3�0CA"3�3?�:bF�V��.G�!P&8M|�vs@;�>c�4@\ �]3�0S\�B�	43)�3�5�y��5[U�������{!�r4R��l�g�����vG��/Xb�A�~I� �3d.����(���Y�9L9��ˢ[lUrlO� ��9L��Y�c�;�7s�=,�:5�c�D��6���f}��T��w�=$9^k��h`��,@�z����6����t���3�r���]��4��l.p���t8w�°a-��3Ȍ+j���.@W̲�;M��F����Ԅ�q^�RK��F�����h�ދY^������Y�ܑ��ʺD����RG�-��;]�Ƨ3Qt���ދ�K��^]J�%N1Bb��U����2����	�p�1��- C}=�g!b׏Uf�c4�֠���� Q��Jl��F#�B�ҵ���Ĺ �ל�
բZ:�zT2��:гF�,NKL��T(�"62J�F,�<�D�ٌ�����U�Q��j��N5�ߘgG�ks�7i��givB�C�Iy��Vs$���ac��6�[5%��A�b�:����	�w%u(U�H5a�ME6���$	k~9 i��S�v� ��D������� 7���c�Q�~�obV>���y3�Լ��e��Sj� 8F%hK��He�b�|�OcN�a�k��j��~�)�N�1�~�[#���B�,�GHf^���6�ą�_���c�ys<d�9#����B==�� ?��%���+z�l]ٟ�,�o�{����{ٿ�:������1�	�xB�����8ԩ�����'>_'G�2��Oo}��<���kk���k����m[y�]�O�5/UԮ�Fs�mL���Y�1���1��}،w�<���shR&0�&�@�_�=E[
h��Z-�b��Tu|d�G
���r(հ��Qf^$M⑩θJV��;�
�«�%�7$l�<
��T]��֡�1�wm���*-UA#�Zc�).:�����{)1�Y�QX3�"G�d�ݘz�A�yM6�&jW+��6sˮ���6^�l���4}�2��9�,40���"3d���b��������B%�U�D�އ�*�чT�.ߕ��Tc[sͼ�ϦX֭��������Z>Ӎ�P�:c��H���(ƴ3��4�*�h�FEm�,�^[FX����Z?˿�*V�:s8��X���P��e�(hQ�gtNh.�f.f#{wKE�����#���Z�lFIe���9��b~��yB�Q�L��<��t��B��(B�*)a�1���Y��YTEqK�T�b�B�bwP���͖��f��z���%�,���c���XN�x����0m|�
�G����A�#��q�[7�Z�͛�ބ�z�D���1b���[�]�j�q~��h�pVU<L(+����n�[q�)n;%����Zv�hz�*��
g,vQz7���*����ݡmP�ȗLQ�z��h�@M����2�r��"�@f���]�Aw��fy��&.i.�i��:($t��>ϴy"��n��n��dK��a�:>	��y� ��7� �E���y�JR~�cS��4"n���)*q�����H�dP����a��ˈ��D-��wb0Z)m)˖]�%�x�W�pX3S%R��V>4�f-ܮ"F�Cz
�v�4�1J`�T�*Qu�9��5r�*�!��x�AyU1��=nZ�,(�~5��D��}��DB�����T��hR�fF��*Oc,��S��=�%_�o��N����3^R�wx ���<�Z�JJ�&`k��Āi���=x� [^�'+t���F������b�Ζ��L�^(E�s.�Xr,ٍ�4h���DZ/O��B��s�g��ތu<�<X܄���l>���'zD�dJQ�:YP��M6�w���'g�&=h��"���H�֛.R�F+����n�g�ݠŭzg�Xu��ItW�qŰbL&o�:����G�A��&�d��u��U�X�X�X����q���!�"Z�C��X=�X=<�������Y���v�5k�=3h��Ǧ��?��W�Ňw"�3�G��s#*��Gdbz�))$\�|&�GT�q�:M�U�3.��4gBG}f�˅f><����Ӱ�:1�C��2��T�c��]m��{D-	\��	�2���.�
�H
|�0tx$=��A�6�-�-��Lk�~]$�N��M���Q��Z�"�D4q�����ȆD�ٞ���=�;�M1�`�A�-fH_k�_����V5�7U��.d�:��D΍�
�w�Z�̱�(�5��}��]C��6��"�ɽK��N��i������MG���߄�@�}�qD�'��o"���>�<�)�wD���е4G���P]��:��x��m��*=X[�b~��]��o�Ͻ���;�<��I�̦���OB�dp+=8�N؍S���4G�s�T6���t<w:���%�c�_��f�k�S�����T� ]O�pz:$�AB��p�=���oA�X�͘Sss�2���w��������p�\��qLI�V�Z,�"$�%��9��R��|H�������Q0
F�(#	  f4�  