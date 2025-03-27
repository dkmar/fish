function qmk-push
   set -lx PATH "/opt/homebrew/opt/avr-gcc@8/bin:/opt/homebrew/opt/arm-none-eabi-gcc@8/bin:$PATH"
   qmk compile -kb system76/launch_lite_1 -km dkmar
   and qmk flash -kb system76/launch_lite_1 -km dkmar
end
