ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1.sh | bash"
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
WORKDIR="$(pwd)/composer-data"
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
docker-compose -p composer -f docker-compose-playground.yml up -d
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
rm "${DIR}"/install-hlfv1.sh

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� Ϸ>Y �<K���u��~f��zVF���٭�L�׫I}{&�0IQ�VS_�;��)�$Q�H6I��cl.�����)G���$G9�-�1� �$�)@�KA��������q��Qݢ�^������>jk� Iꚉ�"N��6R��ӡr���h4�|�����*���!ׅB���h�]�����22-р�e�c�<����2F�)k�Cx������,!�! �u�x���o�%�*2���=\����P���TG���]d�+*��a�J�n���w�:��eCS�H�@l�/��\���%3����y�ϗO�ۨ#���TIT��:������tĖ!K�/V{H��&�]�	Wzn��6Ggb��dJ��;$��`����>q���������VE�li��iC��xp�ב$`� [��mZeK��������Z:�md`­O6�6gg���P���.=�X��D�
���x#"�K�uOO�$�D<�.��t�����3	&otI�\8!�Ό/X�Y��Y��M.��/N�`����R���t<B�U)���D�k��M�N��c��(�Ѕ��j}�nijcڲ�\��
�?�=�]���J�K��&
N�Tdٚ1p}��5xM,d����/����|Ӟ�j�'�@�����|�4� �EΊ�NY����?�3�k0��9�R����e�-$m�ViEI����{-��GΜ� C��GC�(��95$�������<ؒ�`K4{ ܂]N��Hu�"h�DdE��چjc�+4F�*�ݓ���N8�����(��o�k�*u����@����~�����#���1�z�g1=��ɞ����%b��#Eq��G����:2&N�W�SgR/9�\��Yc]�0�q�p��\
P[���%�P4��0���<Wf���Ўe>X����{}_ƴ�p�´� ���=�_?Ԗ�S5����-٬�'�<���ϱ�8��nh��*SW(+2��S[��!W[v�V�c)��F�����B]q$[n'�����Vʃ�r豿� �D�D
~%�vO�zPs3w�%���||�UPx��F�����e�w���9��
eՙ�9�'?z���3�U9$o�0��e��}פA�2�8x��p���ͣ�\�0��ּ��ښ�ޒ�gW�ʖ��(�gί����O�����"12u��Dx�����S¾����G[6��#�}9���r�Rb�'va�޹u�����\��d�;7�;U���"��1py�������������./y��F�?�{��������l��E�z�/ ���$6��Xd��{%���?��Ȕ�pKՇPV�(
tu��#|�ǈ�z5;���e��K-�Xś�'�t��Hb��5e�����O���8���0ی�����j��G�@c�h�s��ۙ�N-��f8�<��6��ch
���Lb�۠��{$Y�1��	�L�Y�-e
��c߄�����:�������W�_�uXr7�3x�y�fJ�Y�+�3�����ɖ�|�k �&�&����i�����8'��z���Z )&:'��l޽�ބ�uv*O�[��L��\�"����6���g"<Ym���!��~LF�18{Bz|�O����{��Sy����'��Vo>}
�ۑ��ҙ�>�9͂"TG�2���;�#wK
�N_G&�tS�k s�.�Ĺ��T��7���׵����-�C^�O���bD,�;�s���w=�ki�y��b�O��$���_E����Φ�y��F6柊D�]�we���DaM�1�0-�C3���!��;5�8��N�������+g��7���=.��G��SjC�۳`k��a����Ks�,�-��.��@�4Lpƹ㞰���\��_gS�<��ac_�'���U�ߨ����F�#���u�+����:t��S�`q���zi���}���x�Y4 ��}" *zO<��$�J'	��W�7��*���k���<c�/j���)|��Gc�뿡0���U��^�?/�;kSN�95-4��o0/�Dv��8��B�_�+ǓM�� {)p�с?	�/�A�\6��ۆ�my�.��Ž��BC�1�&T5J
�7��\<��M�������O��������I�j���+��0�vFl��rm|3�4��
�U�x���iB����'�1���9B/]��cE4J޺��J��E��T��l�ܱ�6�7q�5Yg����<M��U�����1hp���]���ҭ#� �����p�#w�Ip	�oMn5yNܑ�
S���wzZ'��[��{8�|om�n�b��i��:��\c�<�y��c��������5/���v�
4.��G���n��*ʥ��p/H����g��"����b�]���~}����wn��W���|���r���Ev�&:$.�H�"�X'Q�VDD�1nE;�����6�b��B�F>ޕ�a�>���o��?�7��?������\��?{���S߯���,8!z�Y�?��y��������� ���߿|v��?�v����W��~��Z�߾p
å29�r%!�̰������d�ϲtI��v��,�׵�n#�՚�Y��p���s�ɤh����G���Y?T�48�6g���I9^�l���ya`���]s��u}�Ɨ�6�m$��b$hk,K�4�N�С�'�&��)fz�*���˥Xv�lsi���L6^c�zDt�̠����V���To4ݫ�줜�()VKi��Ҭ(լ�Ff���]ģ%iR�$�Ǡ���j}V���j�Y�������n0t'��E<�"f�D���%٪8������q��w�i;�3Ѥ�<w�d�b�gDz��#C�,Mti����";�w�0����^��%�9���}�jg�G�F�����Y��L7�z(i�9�Ӭ�(V� �=��D��D�N��c�j �K��
�߼�ҰY+M�����)�G��qF���N� �H�Bu�ʜR�f�;������x�Z�'܌.1�\c�A��J)C�a#��M�}��IB���d&�arԠ�Y��O�	��hKamLU�X5�P��jg�(p5M�Q�&&�=���\")�)���}iYǧvFz������x�+��3��'���L[C�Ǘv�v�ҜM
�Z�[R{�aN������]e��l��&���<c�F$�`��qo�����v��<��9��K��(�����Ԉ�soҸ`?��=�q���5*�A�=�sf����cNI�Q�Я��-�[u������!1�kdܮtޑH�ap�ʊ;a�ơ�i��n�s��]p��%ރpM1��A
8��e�ereU��%��2�PI�������G�Hd\1�m��|��.�
x^�n.M'��1:���d����4JEr|4J6M�i�&M��Hζ+��)��Ym�kU�SH��X�p��E����RM1�M�O%+/7�s=l+�x��K=,7�J<_x،����.�]�Vr�L`�$����x��NB
��(�K�.�(��H�&���Ҳ؃VS�i��yDFb�^�Ȅ*�d�k�ԁ����H	%{e.)(��S��,�����lT,��f!XT��%�TY��a����k�s�
NyVz��&����a�N�A#i�BM�Ͷ�r�y�J�
��P��f��9��^�ڣ��gc�S�>���X����E��'��x1�}��½!e.�,�Ty�2�&��f�(z,Y̦1*7���bu�%���cEIMsUf��Z"�Nډ*���0�Ԏ�=Bl��T��ԧ0le/�,tQ�f]ɦx�V�,���b�.�Jᔲl ����,i#L'��I��%Ys�2�Z�����Q*�	a�h��h�U��S�D��zh����ͧ�Y�U���S�L�7�::Kw�Ye�lS��e��\Y�P�t(c�b���R5�LR1ts�ޔ�fT�;���J��cz	!��������z��W�ܬ��G�8DqdF�r@�Q�S�����4EGB�AS�H�X J�T$O)����RL�#�hه�!O�n��y{*�v=&X��V"B��+$�]PD{�8����94$�U��p���RB�'6S�4G���Ѡ�2e��r�]ζ��.���|��=���B�������|7}�}���w�_���ﻫ���Na0�=�A�Õ>7|����UR%�\%������2�%��_��F��c��=*B�%�����k�w;5E����>ߧ%	��(^����XoM��Lːݽ7�w}���X\�Tsd
S�n���-A��C���<C���}�:���W�$?��+��)�O|]��,��xg	� |�qv��"�]�}����p9+��b[��+Va�x�/��к�e�����_}�����_�n�@�z���ʢ���> �箱��il�L����R �����7|�u���7N��^
v/~)��sCw�	�R~����d�~�=�����r���p�e]'�g�|Ѵ�ŻgV+3N�1!G�X����)֚8�E���x���	��P�Q�kNA���\����l�_�#�oN�����eΙp$.�'x���s� ��VO\��a{Y��;ږh��d��Ƃ+�f�l�g����{��A�P���,��]K�+�YNP��E:2Ej%#��[�W�S/��v����)��o���]�� !lX�PvHR$H�$VH�bQFB(��"b�����v���]�I���^׭:Uu�<��������"�vf�(9"�؀�i]v�gY)V�;���IT�4�.��F�oL+��G��j	/y�m����J�+�P9bٔ�U�y���̲�W�"�9��[�Ʀ�DUn9d��M�II��3⡉ cd2//�������f[�h��L�L�ʙ���S$Iz� ��is�D�}ёB��P�R'��͝>a�Y�U|�9�G訄�^���g 1�т�I��x�R˩�9ń����:��ȱȕ�����zB�/��o���Z0ٽc#3=�t+�}p�5/�;7|����W2�F���w��[�c��������,i?=���"��֩JF�u�����m����A�Y�i�#W��+�oe�6gB7�p{F��Mz�Qd�+he���NϚ펇��r��C��� �43�a�)F��3�g}�GX4+�3͒\CLJ��(��FL8۞.��|F�p���	�!��]c�u[t�1��"����S�i�ZZ�g�eb��<� ������1���޾&�lm!^5��[�5�X�A%J3��f.m�|���!p!�B��L�YoQ��]�Շ��h5S�.�hQө����t2MsH�]�6�'��@� ��u���l��� �;Z(ۻ�����`f{����l'jcM�?dx~<����hi-|��<|i'�;k�&g#�qL�+�/A_�s�&�����\�a{��읝���l^�0�zj���J��vT?K^}|��g�>�s_A[Ϯ������k������}�;����ѿ����V��-������n �8��s�������ڴ�W�������S(�?��{����?�շ��G?y�/��w�~���_��O��?���~��o|��ϓ���П%!z����|���.}E��W]�M��og�}�'����o��_�~�������3'�O���g���>N��K��_w\;���'���?�����v7�& \;�,n�gq�A��k'p���@f2[\;������G8U>����"���}_Д�3��������	C����Ď��2>��kΟ󍳏w\~t��X��T*�J~�s��q2?�G�H>�k g������2��$-�fX[���, , kf@� �#�53�X���%0A����S��0�=�m�y�G�Й��K��������h��ø����n�O!�U�o
�)���c$��# �5޲��`@��Z��\@�纆\,��[n�q��]1���������7��X��j�Z�.�*�9�}�).o��a;W�x�#A�gB���u��s��e���3V���_yg^���~��ð���z��S�á?���o}=0{�u��q�1��㺦�uC-�$�C�f����n薎��(��Sg!M�Y���K��G��|~�X�;p?����E0�����SF�a}4��k_��[��d���.X����~ź��0\���/�Vr�y��w�v��1���=���Onm[�(��eLJI9.y�T�)ŉbN��� ��nM��敼*��Ư���F��-x��F/��3���'�(⛫��{S�!�r�s����>���_ze�'%�[��Υw��䔒'J&�����]g�6��~��Y;������;��K���w?J���_=�~J���E�J�����2��=�xrޥ�]���`7�6n��H���8��;�����jm�j�'�1�/.EH`E�]{�@���������qu��\�7�r�Ez�]�����t7ܶӭ� �sҥ sJJH�ҥT��bA�l����~ڔT)���ts�tI����I+�I�5��a�i;cx���Ѥ��^;�}ygF�ڭ׵�>o����t.�<X��×/����R�!�wVH��J,�����|í�t>�d.ӹXR��v[>6���I���?�+K)��ۢ��ۉi?��E�7��A����>�q���߽��{�p�	���rK��vm����1���/�8���3�m���٫m��cl��u �-�}s��̹�,�,�h��9�mz��y�n�>��ux}��z��}�i!�}���Vm���r:�P���f�\��M��O�w�<�����F^�ϼZ�jYB;-�	��&�����q��^�w�OO�w[W#��_�s_�i��0́�7�KOB�~�V�Z�)z;��?�lz���Mo#�]:EC��������:�S�@�ا��͉��vj�L@8���_=z���?$�����������y�;���0
�x������;���F1P�A���5<��8��q�@����k�ä�o$[�{¸<;�˺����$������ϔ�=l�d����w�3����������:���G�?����@(��F������9w���AX �������C�'���?��:V�u3�4J'4��i���:Ih���E�Y7Q��Hӵ�A�:�"&a^:��X_�����'�C��_�Ϊ)I������<!U�k�d]ಒ�(�=s��n�`��0�Z���Z�,ʎ�]�����O
-ad�,���%?v1+f�Tkի��dD7�ҩuJ�|�����؉p�Qg��X��jN�H�И�8��%��N#y�� #�D�ݔ�Ӣ�/�b$�fg��-�q�)�0��4v8��`����K�uߝ��yB�����=����1�@�#i�8�,�:uI�L�@�C	;�
�A D� Q3@Ԍ��f��g�0�(������@��P�����l�/���7��o 8��6��!�?z��O �?ܧ�K�~���U|�T� �������`<%;#uN�������Q�㓯�C�l�W�*�YW�j��JnU^��e�(rY};[;]~}�:�.�R-5ƹbc��g���<�G/7|���ǳYu��;1�����]��]�_P9�M�b��y!�*6����܉�U�+=��y(��w&ĳ%!�"E�2����}�ш9�ss�҈S�^�+R�kk�(A
���=�{Q�ERnG�����s���ع)�	�j�g�����m%�����`�y�NI�����x}�:� ������	�����p��/[��c����& ����?��B����������0��r�a��@���!H�z� ���-����A���!X��?�����O�� ���p"�'M��p�â4���[8E���:CДf�X4�3���)�2-%-�k+�A ��!�_��8"����H�y-��Zq�Qɲ���;I�*��|��b���3_��c���4Q��D�Sr)+L�o��j92����pbF륎���=�V�М�`�B���!���q"naU �l�W�V��x,�0����C��?��6 ��e��a���t8��P ���9!�����?���� ���� �G� ���-����A����T��w� N�P�� ���������i�)�'&	�05���酟u���~b�s�%V��U��ޖ�r�+�}]h
U�*ϻ)���H3�3hF2�h���%./�;�:�#���$J�r�v�Ff2a��"�\�P�Y���Q
��.\��a?�(�9Lؘ��K/��,�풯q��G$���.Ϲ��n���lQ�/���ba0Dq9��l��VC��z&��Mv�e���2���B�EI��Ÿ��dx�S閴��F�H)��G����by<YІB�\���]��l��t��s�d�M����fӕb�!(r���u)�$R/�V��F'�qQ�#�
�C�.Ƈ/^߿�0� �������@���_���8N��`�?,����O0������˵<���F�;^��0����⿜�����zQ����)� �?�����r��0�q��/� ���hd�5�3jQ&Q'Z75�guC�tE�@I�E�:�Xi�(͒$��(ώ ������w����)�����p�R�F�VjjY&͵'ZͨG�i9�/��EF���?P�������*�z�7m�Z߭+l�H���\�0U���g�u	JgD���qHL`�b�-|�b��F�R]j6k���Ƨ����0G�)��;���!4���9����*������8�?�A��*�=�������_HD������������>�����C�D �����Cn�� �?�I�lqr ��j���������,��,°a�X��i��hK�:F!�N�,��e���n���e�M�eXŏEP��������/1��Frfmn�����4�f�H"��zc�\>b��1"��;�u�wX�	�'"9}���\N5���t���N/�ZD�9��SY������#N�c3D��"��g�T=gf�L+����}4�0�c��I����I�������=����q�<���;��j� �%���<���}���/Cج��q�1Tl+]e,�%�"W(�c�*X�]Sm�_8���R�iE�1�����"�_%���k���jQU֕�EU���u�^i�VVqf�Ef��PE��U��ռss��\m��sj�:\|��j⺥��S]i��M�܁X-��;���M5Wu���,�h�Z&�~�Y�:��B;YK�fm�3���ʲ�����ʢ�}�fi�2F$tw��\*�&��U��Wiy�Dz�-�m���� �df�L5�E�#W(�M99���S�+�)!�.ʃך�+.k(��k
\�QƭV1"�� ��V]-_[�l�|�*�ǜ�Z�&��Uڂw&+êЉA�Ue�l��T����9-Y�ˎw�N:#/,��D���f&��&Bz'>$�)s"/q-^�:���"�.�s
��4t��Dk�����@����l%���)s�Y��(�T�4JZ�����Phk&=�W��\��ȵ��_�z�P� ���pR�lqr ��e�����k@�!���3@�������C xX���6�K-�a�|<��xi-%e�,��/�'���U��恢�cP�l�&�C����Ł�c�صZ@��i��I�������-F��*۱׳wc{\V�z��N��ٙ��~��8�~TwO����������ꪚ���j�)B
%��( �a$��>@��"[�H@F"�	��[���y��ֳ+\w���{�}Խ�{�9��9%X����`xّ��I62���R�̘�A6����Lʠ9~���Tp�b[~�|f;���X6�|�B�I���՚�O�ѳ�A��!V�19�������Tۃb�Ro���j�
7����F�?H;fT?�i�������e��6���+���3`TOD�<]���ȝ���1�5���y�pz �?�1��8�^J����'������O���s�ץ���;������c��oɱ�;��������E�8��OyIʑ�/#=�?�?����.)]�;���.c��/�S>�#�_Jr�G�w������ �ډ�u��%��t���~�����@��ݣ��_x|^�HS�&٤��D��{�{��I���'�z=࡜(e���?C�;.��m�q俏>���&�_b��>��F��p��JrC�����(�蠛U�}���(���%��'�R������/��	�I��ƐHT���jAr�/��,�X����R�&��B6nx�@��On�{9C��?.�V�C�-14�Ckʊ�k�V���飽��x$t����^$�J�y�����P�pMś�aZ�h�q�Y�p^Qp�ty�a�S������w�&���l�@{�*
h/��'�2â�୦��G;��n��'H����)�nS��)��4d��W�����I���+��n�n��Tp�0���.�^�]6���$sf߆?k��tw�ŅCX�ЅWB�^ii�����u��;6��6�nֲ�à��Ui�����0ă�hZ�\�uB��!ϫ�}Q=���߹u�~}��7����<Al)�J����۱t2r�&�fLh�p��~L˺��$�$�Y~C�mT�e� w�>(�{V(�}�#.�����(�4��b(bC��;c�3��[���EQ�byojn�D|�k�^�O�qY��ID�G�w���wT�q�kZ�m��n�v�?��ε��x�>ο�������t�����q�>�:�y����2�mp�e�|G��ft����䚓�h�+�P9�qե�mq���6[���٢�Ӆ�ڙ�~u&i���76�-_��t�n�ջ��E`���߁��^�S��.N�ZÕ�8��=�;��i�$���~�����#W־�?_���\W��{�:���ݴ��G´���d�K��~?�	Խ�H��^��k6�$-�I�(V�E�"�?v����=�W�������=r�o+���W����"��ˁ��n|����OO�G.�G/ 0�	����<�z|�y�w�Ǿ��R�<z�Q3(�C!&'O��X�-1`����`0�́�q��ZB*Y�v|�,t)���'-絙�}��CV���ߗ�s�|l����f7�)���a�Nx⩚��m��Xh�g=�_�j���8+��l�Lr5mP�|9aXj�}Ў$�Re\��v����,�{<�T�/�d�k���6T�;��F.�W�M"6�Lq�K��ID�� [Myf|,8%�{�"���h��;ۙ��fSJ�F��Bi�I�N���`\�4U).��[�X��R�~�04��Kaq��匌N���v5�1aB��f�þuű�;�p���%�֙�F�;��FƑ\�	�8l\������+#���sfZP+����7�x9���B���m2�Dz/�V�Vh�^�	��	��׷�l�*�XJ��jg %M��Pl+aO��RX@fC��lv����\-CdU"Ra+��*-��#���씱�#���E�	vD��+L�$��Q5=��+r������/����e��|V�	�^g(����uS�v��J�CZY�峌����h��"K�!Kad��䷋�+��j�w ��#�'��\�4��Rs�*����"�`/4��:l�K�@%���\���Zn����\�����[�·,LVI�̊�E��r�	�d2�˖���d� �!�%��%f�L�WR9ߘ�}1�T˼�W4�݋ƴIt�-���e4nV�ރ�N��d���Q�O��ZiPn�=�x�5�z���/�ďC��1�2<Y�+ K���,G2��D����)ŵF$�{�Rolv��r�K���(�Lyl����*��A�J��&���'Bƕ�Z�s>d��ҲE/e��4��F�w._��d9�{"�d�ۄw���}ސ�I�jHDr0*$��	�!��-�<�"	�n	d��b�B��5+��|t�M�[�B��ע�(�ӕ^'{���͑��m5�m�
�.�6]x�lȖh���������]�Y{h�I쓋G�y%L���a?�Pg{r���Ë]�D�q��6^���BF6�gaOc���<^wל���!���M����4x�Q�E�dn� �	Mt
9Ѵٶ���BWO�`���=�0�El�55E����U{4yy,b�®������y�����k��s{r���^ds<T4�S��a��4��:_�����6��f,��V�v���1��b��/c�ǐb�V�b��6H�
-�� �2�® CJQ�����gr����	�����Oױ��c��~�=�P�
V>�s��=�x,=�x,��!��o��`h��F���~���c�=�xl���Vr���ұHa�iؗ�ł�|;���c�C��p��f����8���Z���=`� Rb*ҥ�\�荹m�3��^��z �+{}*��V��T�?�	2&�`n�X�+��R�B�V�VKT	
��v2m
U_�26�m�rxB��6�����̇�hPʡgf�3�a���e���xJV̀�P��M�c�@��VS�@2+�l'��X_N,�NQE�A#���^U�Z�GhR%܂��n��q��=��1���� .Ֆ��r�Q")�u�倩��b���HA��$��A..���!�8�8C�uߕ�^�>��O/�א<4Lk�d�k�s�n{>�P�	�ڼ�]�w&ayΔ�<�?y}�L����KX�K��M��Mڪ�H~A9�w��F��uCHgc퀗� ���V9rw�X�ʣ�r���JfI)2Ӊ��*Ef����(k��Ə��,+C�FWOZ� �
�Ae��3ٲ2�`��=29�{̴J���H Q��,�	����1��GF��/F����R$V^T�օ��*C��BB�~�D�B�/���W����Gq]$c�T�o������vI*���J>�4lz�L�I�Z�\G�D!�"�a!�'�pI6���~����Vj_a��P�<+��v����i�-���t�ծ+KXq8��q#�sI?�e��JB���B�R�T_+��VP�m�gm�]���o�dU�[FO�z��-\�_��Z _�j4�F�MS4�=��zS�m��9��`}�(�H|�Vð5p%c<^߽V�4+/ѣ�!��x{{h.�g���w��{�������o��/������O_î���=Uw﷿�����?�����;E��:����8���:����Ў��$��������7���|�O�旱����x��z�����o�������~?�� �� ~���È߯���+z��-^V���]�q�����J��O�����W��k��3��~ā8�8�\;���>\v������v:������&�v:V�݊�(������v:������l�k��-/���9�*Wq���!�zX�M�]��>s�C��=p�g��{�:�c�9�����	�a���#�9~�)�1�:~q8�q��.�#y���pf�_,|fs���|3�h[�of�����of�p����������2�̹y��p�P�����:��Cg�{�_:��5��䟓�t�϶&�;�+@�+�D���I�~y$�����^F"n�&��Q5��S!�۷�3:/�?Ӓ[x	�
���u�[�5-r�x51�zx��f�=S�m�&n_|/�e����N{| ٦�ϴ�]�FuچV�x��@��Ws�-���w�]��fH�23�D<I�#;p��
EU�lG���|���'&�:��p��y�a��� ��l�njMk�"j�!#�Q�g-��lx����*�b�x<�L>���)��t����\�I�<���t*/��)��řT���-\����:��0e4�bÞ��(.aX��EAn�|5U��K�p���FW6ъ�p�Ԍ"wek���{�� 6��Nlf����p�-Y��0�խM�{�*�y��e����i.�4M�/��-��uE�c�x��`�ʭ��T{²8%�5� �<
"J��A �UAr��5�B��}z�)д�]�MM�.a�VO�Y��%��3�^Ԟ�Lz��oɍ�UC����GvL�9����6�y(d�l%�<Boί㝕)�$�#��N�������̇�[�'K74�쮨�w��|!�/�������E߭MK1?�yo�)��&�5i��4��.�h���Y�d�f���l��|Ot�-N���z˞QMݼ��L�4E܅�Q�D$a��@�ڳ����^�.�1MGqLpv��ٜvx�!χ{g�i�h�#lN����h!��l�w{��6ǳ_`�6��:o�]�6���@."��v�1πt;ch�/�w����=u2'����|V�q�D �؅.��f�W�	�����(w�d���y�E�P�1�������>�(D�uЫ��'�5lt�)�8@�5]�)��>�0�م�+��tSȣ�7���4�2���'mNYr>�+ӻc��I�8��Ɗ���|������%0�}�߷���p��m��+'&LK���ʬ<K�s�߀7��a���x7������� Ը�$�Xt��b�E���+����S���J�nu�E��䟓E �b���@����}�&'��o`S���������1�)�����m�<@�����&���Ao�_v�cz ��CÝ�B����|^��N��Y����	/��X��C�|�����Ku.: ����/��<-o$��l6B���b=��s`>�t=�G�x~�E-$����O�6vK�^+�Kz� B��J�W0��J���*��z��sr<u����0��� ���o=D��s�$��W�� |k%��������k�~����0��:�_K����(������W�
$�
�B�G��*Ss�����`�+�@��KO��Y>�L�hw�C�����em�Sܤ��vJ��ց�nOU�OO��	�}0~���T(�>����g��8N]��-8cd[�	q�����������@����:�K��.��P���Mu�7�������.F���,�8��y�$,>Tt�����z����;/�?~�d�ם��y����u�-�Ԕ�IF /8}j���-�"���o�3�Lm�����"�1ζfX�U����,,�(�D�ʉ=	�M�Z~o��8:��W���9wƝ��U��?��s.ڠ��E�}���~��[�ig�1�\�1M���"i�/!�4�n>+�t�
i���a�V<��A��`�K�~}��z����@P����"*@���Q�x9^��
�����`�F%�
�(�S=qkiL��!/�}�NX�H�S�a�2#tG�J�Y�e�������,�w����奜������� ������_��=0�h�*��D��S{����7�J>�[���R͐'S{�|+M-ܴ��ҧH��	�Px���VD(���+U�Eo�t߽�iHY���c�t��G�j���$�B�.���64Z,0���QX���&HY�
��;��p���.��ĝ@K�@B�f��!>_�O.�:���q;�=A��p��C�@���v�'��v�v�\3��s��J�hX&�Y`M���T��}���y3ƴ�?�59�d�vJ���Vw9(&%(|��u�^�đ�fM!�X`ut�<���40���rr �=�ES�����G�N��gw�75��r��G4���w��{��*&��$�	�Z�]p���85�PF�q�PV=��ƉE�V�����Ռ�������\��U2՘#��� �q����U�M�#��EC4�O|u�nG�X�
q�~�"��%� �~�4MP.�L���������D�F��H�i<e�����=�f��!@!	1��o�����@�dߩ��A���p�*.��n���?=*^�-ime�ԓ'��&b����S�#���5�\�聼��4�yl�Bh�/�Z��A���PZE "{8{���DWR|	"���%���4�=x��\�&-;|���Ba�jE�o�Z��rh4����0AzIO()��:�`�"�	?2X�?��'"�$�O��9�"{���JsZa!wa}0oZ��,��� ���`k����Ψ�C>�x7"yE>t	����K��'ĳ-�	�B�P����V��.�jT"3�(L��Fk�$�FO�9��R\.�����m��PE����g*�g�0����f,/�;HJ3)�5�Nb�j"��2�����T�c�'��޾gJ�P��^�u�WT��|�N�D��J1{W ���0���.�[X�Cr��t'�d�"#K��3^��t!��:�Z�_��p��(H!��A2��3 ~�Z���:�$��_��u/l��+Ԥ���1���>.�E0�U���J& �nd��	�OZs���`���$b���2=I��!�֝�a��1c��Ԇ��OɂyDˏ�4���g�#����k�}$y�A~�|>I�� �	��vV>)$}%�� o��Gn2O.���=}|#�'e�t0���$������O?�?$�h�a�r�l��\h�KT���G�-�"&{ ✺�h��h$C�b9�*}(�c'���!��1���a6pA��۠�ѐ��1*�ᰶ7`��2SO��g@,i�n�|Йp�ą��,䏣����:)�4��U�~�w���������CJ�`��'<g��p��o�ǯ�.$�K��d�]�O�R�:��v�>�8q0���hy+9
��uHL����Q8<�&Ʀ���iH�LԻ�}�+�������y�ĵ���4 uǦ��f����!������ι�����!����xm�S2_�t�0�v�*Rp�Ǝ#p'�q�}2��E��'�ʕ�\�8��Ȝ#����z���G��j%{(C��0�1��H)<�mk4��;8"�ȭ�(Jx��+� ��XaWCc_6�8*�'d��d\x�/P :$��8�e'>�Y!�i��"�V�iV��>�)�֡
�۟�pl���m2E�´�f�)�b�;dmL�ͫ;� �;.��)�	��qԄ%E�����L��!�zVʱ������Ԭa�~�B��;I
�Q˼r���S��O�¿�����:�\R(b��J�\F���=���RB��"Rn&�,r�?5e���i�U[���������l�Q׾���j�7�P�#Y�B�wj�'�"'f���O܉GnƂ�9�$W�!�e>B�>�+K}�E�R��n9�X�CX��������W�i1����+U�1kۤ��{�?��B�3��q�8�~�E�`ŕb�럦� <�|�'���O�y�
��Dy�K����~�f[xsB���1��NG4�@n�5�DѼ�+L�52\n G������q/z��g����wd9���stn��N��
k�="%<�A�N� ��e>�,�!� 2��,�?�2�O�|�%ː^���~Y�j�.���o�v7��Cs�~+T)s����� �Jqv���l���=)���p�T�2y�LC����5��\D#7��(��'�9�I�x��=�p�mp�ο�
��;P~ōi�hB�^˲Z+��p�F|r5GJ�HehM!͈����d�U��gk�k��N�g1��נ����� ��.rP2�-�0|4��p������@1B�f0�1cW�1��W�\�<�P#�	�Ce�N�Q�f�ݤx��w  �F�	��7�݇ݖ���r���U����5C���������hX���aɕ�]��iǅ�,y�;Ǚ^�* o������d�2gP�W�o���z0��i�غ��c<�|H|d��V��jB���5�4`}==�lk �lB�!��Tr�8��"�/�;D�g�!����x
{����W@/_�/�+��R\gեjM�*P t%�M�Z��&`z+���;�wq�q�-��R���Ā���x,�ⱨ�X_�귨��{1�;��d��K�?o���������lvM�C��/�s�p�w�/�������>^��4�Έ��q�;��2v�x=�E^�����?��������0���T2��'֨w���� ��?���_^��,�� ��/��;�������K��u�
���B.Q�w�A��ߠ�39���8`+�N��4��q@���-i1C���?�����b.��9��」����D5���iI���"�r9!'�lFI�Z��$�Ϫ�`�l^�U��� �F���y/q�P��_��ϧ�BX���b�W���J[��/�Wr��5����YGZYnU��:o͝�=�*S��ʋ��㍝nu�ZB�>6sW��|O���e��|)�|�.[�VO�����qgj��S'����JX؂0<盙���'_؃E�.���O5~�ӛ_��v��jdn���u�9�W�J%��*5)7�4*{�?=�?Z3�MO���6�!�	��,��q@���̎��f�6 ��>����/
��������grl7=� �2i1���,���W��W��W������l��' e��2�������~���[,�����6�Q����$������u��lE�/D�����o�����C7���O{z�7;j�O����)�[����ܻ�7�����#�Q�k�DTD���l$j3~~�,?7+U��)�Vj
��by�|Жך����,�n;�y�i^4g�*Iaԫ�q��z>��мo^��j2�wT�	���L�bt|�Oǚx���O��YW@z}Ѭf�������ZN`Eni�jy���`�<*�+���<��p�~.��R%�U�{�=�@@X�j5ID�&��e�4C��7�/7ey֘a$�rkV��ظ~^8��zWL��3{�j'δ��l^>n]�[�lev3�e�����T.f��B������!�RC~P���U��KO�w�85��
��lp$���$Ӗ���aaa��[������ԗ/��ָ����vB����IO���~���r�����������Y��%������m�����?,��	6��Y�;`+�V����?�������l���������	,��2`������B���?6q�v��v��L�oZ���?6��YC�u�YA��]I)��j7-e�5��IJ7��n.��E��J�dt5!��\��guv��O�-����?6�8���8�^.�NZ���w�*�ӑs��Vڥ��,>k�T{�,�מ�1�w���m�!swX]��O��H7����k��qj�ԫ��?Lwr���mb!�Ag �ҏrinL�]�+݌��|:�+�;�㭰�����9�����?�X�����6�v���`���m�؂����� ��?l��������?��������.`������A���?6�����,�!؊�����1���?�����A����I��%�y�0�dŅ������'�����U�Y�u	�?Tg��S�it���6K��iY����Y��ȏ������m�_ɍ�sY��\��Y�s���\M�/r3U?�N�C��Q.�:�îa�G5�OXf����E�P���ǳ�g8�o�!l�B�]Rd8��w�$�����R�Ժ<�[��C�3�"�$7ЬW�~�\��獙ڻ/L�y��P�&��T�Z7K����y�ܘW�C@hz�u�R����<<l�O:�cyp}�7\�	�W��&'�ri:o������m����W��\���Z���6���n�5�i^�5~PΤ�	u���]?~�x?�����?6q������l�o�?;�cs�)�ϊ��[����ƀ��Y����?n>�=����0�������l��������gn��C����K���������\��?1�����b�w��z^ɪiM�5/
]�Ȩ�|N3�����tAӵ���|!#d��W|��!W�f%���������E��!��������|�Z~||<m���wW�J+&?L�;]�=���[��󺙭�=�C��m�7�N�rM[��Դ��ӽ��fw�7bJ��;m8;O͆�t��_����y��z��a�н<�]�������L����o�^���vP��x}�O�,���W�����?-"s��l��/d#��a�����o��o+!��A������/�|P�gsL��1��E��}b���?����B������X`���}b���?�����i!"�����ۢ�9>W��1�-���(Y-�HI�D�׵L� *���s|&�iZ7�M2�nW5�B�`�P�6�K����+����+�g��q��ڷU�7n��ci~��h��P�[�Yi�j�M�#��M��/s-5j�]h�%�pq�4J�paWr'�ji0<|�<+{塣�?{Oڝ6��|֯��̻�#vp�x� ��-8!s�p� [H�$�8�﷿ꖄ��I0oF=����^J����A��HT$*��M��-L�oM6�P�q�Ƕ�w���8��������2�����^Y���x���l��?�	���J�t�';�-v�t�_,�Z�������v�������y���T�_+ڠѹ�%;�u;/U�`�ڗ��]_�}�c��ߍ�C.TQKoh�|���K�v�|��������8�q|;��U�T�E��c���g-^/x6�g�ڝ�xV+u����N�b��V���X�*[���Χ���ݼ7VF5�3+2$���b�Χ�S?�z�.��S�Ӵo�얱�Z�Bƈy�Ua,�K��6#��$���Bk2�fz���,v2e�|;Nhl��*���	�|e��N�_��~7��\.=�LY����ͻvY�3��y��_y�|N��g-v5�ܲcDR� ��б��� ��Yn�a�w�`�w+s5�O>�#��}�"�ʆ�\>W�UQ.rB�˗Ve�}P
��f�qP`���S�is�3g�$��ć�� �e��c9'��3y��mM̗��؇��V'�/�,�S�|��7��~[c*Ci���㧇�vkT�⬘I5���)�v���>)f��R+����`'a��^-�����S���������x���U�����`�秓���㿤����?F�/�����冉�疕���}(�V˵T;���e���,��h�Q��Ԗ�(7̾q`>�ā�^�l�]���Fp�Ʈ,[,���}��zk:z|+��\+NcE�!Y�ޖ̦9�},��֬��!*u��wVq��P\ڼ���^�c�*����L-fS9^���u���}��!����S�����>�:w�v�soP���U�y1c5^�Zkߛ%��}����rjVV��7wB�S���Z��I�oR�^�T��a�1�~�
s�q�g�y��j:	�/�s�'x��Q�+��� ^9��?��;	���9���:J:�l��R:	�?������������������(����- A:�t���������?B:	��Y;���;R:�����Mǒ����T2�����?���?��_u�'����Q�d?)d2�x,K_�ҩwI�*#]�ө��L\b�DFLDR,�K�I�AB��iQ��zW�D����N�����J�?GI��ajn�BE���o��m�/\%��r_�a�LE��f�ʇ�hc��V{|��nj7�x��(5ҙ�n�s�d�$�7��H�FT��%{;=�#%���.�vx���ҭ�#�j~�koc��r36���4���5U�D�����������E�e�� ��u��B�ά�.�e���K��{r2�$Op���v61\fh�b6Q4QPF�ie3�T��{"�9E�TbY�j��[)~{��FO}��u"�V���e}ku[N����n�M,Zx�����t�?���VPx�J����F��*\��0@�ItDwlđ �G}<w8ycS�pV�5��>�K���?	�ՒǤ�D4�f��T����1Ȥ�i�OI/���oWP���k�d�-8�5S��cŧ���?O%W�&�����'<�ɳ(Q&Y��,��۳DJ�ca(e�T��H�!�c��B��*�M'�1:JGÄ&HI�ʆ��A0f�FE&�U��<C��uD�Ĉ/V�IA]3,����� π�Ƃ��"s��"
��@xz-�'4�zȊ�vּ�r��]�����נ�p�hIY�W��P�O�`�)���#��Wtf��3ު%ȪdtUaT!
] ���P�*�������h�����w[�g�EYy~�r�_iu��Ro2|�mp�c�n���S�V�*{�V��`��֙B�cy�:J��6B�O����V�Q�Ɣ��X����=�CĚi�14ig�������3U�*��] ~�+d�`d���F�*߅��UY諠��;�!?ܴ��,e���Ec�ۊ˳d����[�q�F+���nG%,d��<��Ġ%�Aǽ����4�^V�ݾldQDӭ�P�k112��ѤG�@�a�Y[�L��9�mxb���[Ȭ�@��~�q��*���[�g��Ky2�K�)�/C�����8��6�97w�������ܪ��g
��F� 4t( �4�&h&�LI��"`y���C�*��Q4���Z�'��ȏ*
�KSQ�QE�$c ��U�WК��2N��Jf�3<(���G�d�s�=�opl7_f*�|��v��l��b[��h���a��Y�`�J�Եe|�͵K�����ֵeL��Ƿ5i�f�Ro]OT�\�v�"S��5b����äd����y �� m���[d�WN���8q�|��i�Q/VJM�U��޸����W����a���γ��ܛ��X�\��.�nk��zcTE�_?b]��e���RxM/,�&a�g�� yC�r�)�6ÜkJ�E>�]j"��e`���2&�ąL`�`����� L[(������\�M�!I��,���#k�]h�oX���l^h}jp75�k���Ka�X�ea�JP�o�ڵ���cx�ڑE[��v�\�95:�\[Y,alߩ��<�ۅ�����^���P⺂�-�2^T"+K�T�BZd���u��t��Ϧ�Y?b�jζK|�iU_�%�ov�C\�sɊ��Σc.���ۋ�#���ӏ��!W�h����t�{l������\�����O���"ܤ���0�M��P�	M�	c��	�k���U5a���0���p��_�:�t�S^t�C,)��?�w;�w��fb����o<��%E~��o�
��jJ}4Q���<etA�'���(NG�98s��.�c��s�"�[K6Y%�DI��Ʉ��"*P3N��qtZ�$@~��H �K�l#�f3Z ��5cQl03R���:φ�xe�h��d�o��t�7G`.B��T�04��y`Bf��U�%2��5	��˦eȽ��4^n��^ 1AEg�*�]P�/1�O�VL/��8�ު�<jp��J�Ҩï"b�tS�.��%a�T7p��2I�O�����&`S�hM]�,B���lI4Ԁ�U�tA��eϨ	�c4�<�-[���W���Z�;�
��(E��h �kwP�0�:�
m`���@���70����9ɰ�<���l:V�Dc����"!�76��Y-⬅o/� 9�@��am,���t-��h�!AmW:��*yrZ����Sj���&�$�`��|�o�|���<�������_C(��������/�S��"�аs�CLP
=��o��̺�}�8�1-��y������x�;MVϻ�����%�鱵5m�����`xB�ksKTM/����>�i�1W�aL1�o��0l@_a�$���F�0�9fc�XP��{+1r{��/�[Z9��I�M -�m��cd��7��bQе�OCn?9w�_�N3)(p�f�M���,��`��Nĕ���`	 80i��>d~�����}�LQ$���=�i">M��=7�aC�c��� ^`~�d08�x���=�i��C�\������(��۪��|�T�`% 	��8��'D�B޺�9��ئŀ���p=-~]�o�L����Uo���	�&h���h\36&z@P�m�r�h"��F�v}x��R���V�����9yv�����C� �yP.Й]�"�P��d�V5��D%��a]�$� '��B����ɒ�d�{C]������ʂ1����Q�2c������ ~"b�:�(�s�X�!R����J�p[e�3q,)�N֌Lp�'~��K���M|���BN��C�嵧Kt���;EAVl���rOh1�q�_��F�6#���f`5��x	��;����$yj���*^fNwp�D�,���{'��#n3�������;��dT} $�
vKs*�6����4�hbCPMaI.:؀:�n�;m��&'�CȅB���܅.����5����^���Y�נ��v>��|�bev6O�=�}�%A{�܏!LE������%�a�̬[/@�+�n�����Cq8��*�Y@��gAxx�{0ꞿg������u�to�	��1~̉!�F�D:Lwv3�>2O��ڎm��J����׋$�6G�ױ+�G2�XY�I�G���қEz��	戢� �A���@6@KX�\��)��DS�c���Dai�˔�-�%��0�/f�q�1_|�)|����s$��p,��-���.�hsy���_Og���"}ևo??� Nmf\����#�F����pd�ޢ�ܘ�x���H�ߠOg65S�ǖQx���3���p�?�E��0���3�����D,��p��S���ؾ		q-aH�cU~ޜA6!"h�d��k#�>`�|G1���
�����ܖ�ϻj�|fb�����$X�h�����H&����N��w���.����8��~�~�r����Д�����X�����7�-�zc�Q�����N)r��Y�놆����	�Ҋr�7\CG�n�e��*��$���$���a� ���X<�f����ߣ�����l���UU�Wa����Xj�Jߙ�����s��}�Ֆ4�c�>㻽"��D�����xI�������Θ'LVEli{�L4I����XL�%s"�c������[��gW�����ɸ'P�8�Я��`�(�x�1�"'�֎�؏�ҷ�!�2Q����A��YEw�W�VX�5�.��N�V���3��������5`�<���5���\T�
*j|�_��=�(Q���#�QD��ʕ 'ԡ12�١1����cu{)b������s�
���/�7}h�Wg+[/"f��_#z�X@Z�v<�jhWJ�t�F��z�dww�u`|��<w�BQE��gj����NG�]�t5�w4@2��}�����p���󟈯�� �Ǒ���+~v�l?*�ޗ9Vڟ�_���������D*��Qҩ���/�l�������k�?m�	���7���(&�[
W�w��vk_.����n������:����ߣ�S�����Gnlفy�8��CnX����In��n����^�pV��}U���N��Օ�r�ԇI�����?D����7���L���%�p��GHc	/��T��Z7Gx���. �Qh�/Dy�/��I����Z��x�d����?B�T�no���� ;vU��ľm�}�O��'v���_�}n�3�V���ؼ'P0	�"$�M�>Fd�q��ea�aמœ��:���ϳ�6Wiu�#8�p�jz��vw�K+P�c[׵YG���D� Z���ń/��j@H{k*�~��;�奛�[�)��=|m������m�����2E�GӁ�w�t��?ξ3�ǈUH�SL�+��d��ý����?�����w����5�/��h�{A�B���.�FT���3� ��華�X�eŒۋ9�o�{�?�s,S����0�������c�jc��rgڝ��t���v�E,�":�W3�G�$���I'�w��8���q'���	V�V*,H���Xi�E�X�@���
m �/~�HH�����܏��w�鴔��&������y?Λ�����\���8~2�Ջ^��q���]�>y�aՏ�q~�����������(z!���������0G.zz��[x�<��v��a���U�z#y���}!�e�#�c�YQ�Z�M�8#��n��^�#6	=C"��G�!��>��#��k�+�t���J��?�	�L�?ً��Gr�P���b���f��p�m���$i��5�$h�66=%��H�ƚ�=�{
o���sJ�<2��!��eV�o��8��$�,A�d�4��j2��n0^�`M��,�[�bv[w$���6�n�J+'���8�19�OW{`�Yh��y�t�?gh{Nz�ݷU2�ې�o���;��|lW�{Rm�J�1��;�
Z�����%�z��6�vכ�niϝ�g�v�o�w��IA�^+�h殏�R����w���v�޺�����J��p����l����/�J}���̼_c�🼷��C��?9�1,��.�>�z���\�w.�^���o}��>�w��%^z�;6��	�v��]prn:V�M`9��m��;�ˆ�vǴ-�c#��y�I"O������vc�s�'|�>K����7�����\�������2��e�7.C�A�:���5�ޗ1bx�=Y�� 7��6_�՗�ľ���L�o:����j�m��/��z��%�;��]��{���n��7�w����7.'}O�co�(D�������aC�'9f�Xߦ���s��m�p��w~����_���>���7���{��SnΗ_��F�;4'ӱs��x���\g�D^�.%��y���Y9!�Y2{!����v�������?����z�3����W��?�����O���?k��J��U���[*��~~�ҍK	V��k)V\Km����_z�$q�c'�a��&
9��v�\�̚N.��m���8�dɜM��,"�ǝ,�!h��IN����x�[�_���k���柼��Wo� [��N��V�?}���~���/�E�����7�2�囻��,�x��W���y��g��߾r��2R�
��2-34�q�nY�!?��X�w'�����~ϰc�5�|�*/}�Mhc�a�� z@U��
��	sv	$ʭiɕ�W�Z\`ᕩ����u��0Z��Qd�S�/,?��\
��%;m5�]�IE-��-9B#�h��ť�];�1兠�c�W1=m�Wm�a�OŐ F1-�&�W4u�*B2_�cє��X12���#Cau�׏<j*V�Be��0t�7�5�Z�-���'w1y�� }�+Nlnޯj3K�Ҁ� Bw'�"���Z��e�N�e�RT�#�,:�c�+�聦T�n�1Eɍ�AI�Vͅqd��f��`�e;���g&y])pX�1T�E���2͏L)�M�
 ��b��Y*��;�F>h��_�U���H�R�@��)�-R����XI:y�R �RF�{���GѴW5��Q!u��i͖�|�3��䉪���R��L�� a����� �VU���A��D��չ[�)�/��PR���#Eb�J�g�2�A���a����iǊzF�!p��-QAHUgT^���>%6��O�!U��J�į�*N:��S�.YI �5#�q�派�[�48�a�O���|6^��o�"Hl��+fЍ���-����sp_�0v��M�$y#�� �D �zA���	]�Z�_2���>.R��qw��bW�2�>^��lQ�a�V�!T�}ͧT�*�^:�梲 ��)h &��J���)�`�Eq9%Tj52�0CA5f��f~�uj�ZMR���@��$�1�M�v(}�%h��@`U���~����J0hf\��xkD�V�k��\1� ����""�,h$�#�nO{s'���iP�|��Uu:��%Y�ϐ�|/���>$f9�T0y_�-�n�eT����\�Z��H��tQ��x3'���QSzi��p�f46�l��ҫ|1�C����hс�`�ľ�E�>�	���@� ��y�o�b���h��,�q0ds�K�HG3�,u3(�Q>�A�\)P�lu t�b�Ų�T��4��T��|��r�:[Z�w�Y�u�vgD�~̲������fis�Z,k"Y�i�J[��w��]�@�Dѥzz/�.�s�{Qt)t�8��ז IXu.�`QSZfҶX���6��!z	*k�P@_K�Y���c��x��|�֠�$#.�U_��Q�г.$+]kP�Xm&H�5g��@������́=������ũ��R��^��F	ڈe�"�(8�]�2Ӛl{T-��}��M����(Ɯb�a��&��,͎)~�6)/�3�j�$�es�#_UGx�./i�C�v�W�H��	�w%(U�H5��"��{E�5?G�b��)�G� ��D���*>E�q9 n�a���!��d��71+����y3׽��ef�ٓ�� 8D%hK��Xe�bC>�ǉ1'rȰ�5sm%��\����^'�^�`��A�2C(�*����U�I��#���/�"ٱ���Yk�-�\fva�����K ���	rw��![W���M<��|%�y��k��1��@�[��%�?r��G��C�r��o�O�秷>�w���������u����߿��<�x��'��:��*J�Q����"+|�@���y��SD6��;��~����	�I!���}OV�VK��A#7Q	��HF�\C��:�U:�ԋ��rd*S��Uņ�N��@����`5]�F�0�)N��i�;��Aˎ���h���Q����Nqމjx�:m����5�0��RK���`��=ȕb��Fao�tՒ�S��:>p{nS�ڤζ�2P��D�����P�x.�oV��h����[���T���J֫0��=��*�чT�.ޕ��T���yW�N��[e�6yEQm�b|�3�
uB�Èlr3c�F����-봄ţ�6K�-!�j�����流�z���2�!ViG8:�Fmi�5.���	͹��%��g�b��Ѳ�F~d��AT��f<&���h�������t�ͳ�Vs�N�?����P�Jr�EX-�T#[kzU�����b�U�ػP��]T�nzf�%>��|��={??��8�sp/'O<����^|�
�G����A��𿿸��[k���-�Oo�_�u���gBL-u���Vq���$��Z��O���	e9�R�-�a+�"��Mc'�Qc�]�.OQz`X��QT���E�ȭ�Gom���d��Փ&�� %�z�������k4 ��g���|w4�c=�7qQu1/��렐H�K��Y���Xr{v t+U'[j����q���#�R�zaM�^�Z�z:PI̯ul�x�F̭]�>E%�>0��3 �����Rb:�=w	QRx�(�&ؐ���VJ[̲eWt����kf5�T�����Ly�Ys�+�����@��=�a�� �$���JT�E�oaz.[%=��p�0��Wd���aӂ$An��	�%���S}$2eeH�O���0��q��e�fUy"�egߝ���/�ڙ�;�ϒw�xI�?�q\M��jV�P4y� �~T L�%�������,��B!�΀�t}��X�\ka��b_ϔ�\�0;�sAŒ���Oā��a+��^����)�3�g���\jx^~��	����,���'zD�dJq�9sIPN�M6�w��'��&"=h��,)��H��7�.R���V��-��j�кAZ��ab�ճ$�]QƭEc<x���@��1��	�70���/�\�s|���:��:��:���u��h��Ѫ�X��b��b�����_8�K)���#���ִ�̠�v�`������?��8g�FThk�HDy�)�s$Z�|&�GT�q�M�U��}DS�S���X�
�|��UG��V��E{�L��0�,>�ՆO�wA�b���:�@*�_ER�(�$�BO�yP���E�����Y.�z�Q#�N��'��QV��^kD<v�����ȆH�ٞ���=���M0�`�A�-fH_mi�_�L)2��r�T�Ȇ�A��hdL�J9:H�H�l�c3>��#j,�A��q�{�2�m��E��;���#QƧ᧎F���t�<�I�a���F4��&�)9�2��O9���ݟ���9��0�F�b��7�+�Q�v�)�W�����-���t��W��>�����S+���n�t��$�1�@��ҽ���<�|��`~n��&>Bs0ϝ�F>�y	���,������{]�p�^�n$z8�	�n�u�w�BB�1_Ԉ�����X��\RT�^{=��@�Wn�% �ǔ�m���B*BR\��S+�+5A���P=0�xx pp1@�(�`��Q0�  ,�.j  