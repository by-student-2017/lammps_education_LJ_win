# lammps_education_LJ_win


# Note: This is test version. (Please, you would develop them)


The elements in the input and output are tentative.


The Kremer-Grest model is used in macromolecules.


------------------------------------------------------------------------------
�� lammps

�� lammps�̃C���X�g�[��
1. http://packages.lammps.org/windows.html ��HP��"their own download area"�Ɓh64bit�h���N���b�N����
  �iLAMMPS Binaries Repository: ./admin/64bit�j
2. LAMMPS-64bit-18Jun2019.exe ���_�E�����[�h���ĉ𓀂���
3. �f�B�t�H���g�̐ݒ�̂܂܍Ō�܂Ői�߂΂悢
�ȏ�� lammps �̃_�E�����[�h�Ɛݒ�͊����ł�
�� �z�z����HP���ύX��������Ȃǂ��āA�ʂ̃o�[�W������lammps���g���K�v�ɂȂ����ꍇ�ɂ́Arun.bat��["C:\Program Files\LAMMPS 64-bit 18Jun2019\bin\lmp_serial.exe" -in in.lmp]�̕������C���X�g�[������lammps�̃o�[�W�����ɑΉ�������̂ɏ��������Ă��������B�܂���[C:\Program Files\LAMMPS 64-bit **********]������������Ƃ������@������܂�

�� �`��\�t�g�ignuplot��Ovito�j
 �Egnuplot�ihttp://www.gnuplot.info/�j
  http://www.yamamo10.jp/yamamoto/comp/gnuplot/inst_win/index.php
�EOvito�ihttps://www.ovito.org/windows-downloads/�j
�� web��ɏ�񂪂���܂��̂ŁA���萔�����������܂����A����������Q�Ƃ�������
�� gnuplot�̃C���X�g�[���Ɗ��ݒ� (Edit: Dec/11/2020)
1. gnuplot - Browse /gnuplot at SourceForge.net ���� gp528-win64-mingw.exe �𓾂�
  gp528-win64-mingw.exe ���_�u���N���b�N�B�ݒ�̓f�B�t�H���g�̂܂܂ł悢
2. �R���g���[�� �p�l�� > �V�X�e���ƃZ�L�����e�B > �V�X�e��
3. �V�X�e���̊��ݒ� > ���ϐ��iN�j... > �V�X�e�����ϐ��iS�j��Path > �ҏW�iI�j... > �V�K�iN�j> C:\Program Files\gnuplot\bin ��ǉ����� > OK > OK
------------------------------------------------------------------------------
�� ���q���͊w�V�~�����[�V����


�� ���̓t�@�C���̃_�E�����[�h
  by-student-2017 �� lammps_education_LJ_win (https://github.com/by-student-2017/lammps_education_LJ_win.git) ������̓t�@�C�����_�E�����[�h���ĉ𓀂���B�E����[Clone or download]���N���b�N���Ă��������� Download ZIP ���\������܂�


�� �V�~�����[�V�����̎��s
1. �e��̃t�H���_�̒��ɂ��� run.bat ���_�u���N���b�N����Όv�Z������
2. cfg �� Ovito �ŊJ���΍\����������
3. plot �ƋL�ڂ̂���t�@�C�����_�u���N���b�N����ΐ}��������
  �� ���x���ړI�̒l�ɂȂ��Ă��邩�A�G�l���M�[�����̒l�ɂȂ��Ă��邩���m�F���Ă݂Ă�������
�� �ȏ�̎菇�́Adata.in�ɂ��錴�q�̏��A�����āAin.lmp�̃|�e���V�����Əo�͂̌��q�̏�������������Α��̍ޗ��ł����l�Ɍv�Z���\�ł��iAvogadro�Ȃǂ̃t���[�\�t�g��p���č\���̃t�@�C���idata.in�j�������������܂��j


�� tutorial_1_colloid
  �R���C�h�̌v�Z�B2d��2�����A3d��3�����ł̌v�Z�B


�� tutorial_2_micelle_Kremer-Grest-model
  Kremer-Grest���f����p�����~�Z���̌v�Z�B


�� tutorial_3_crosslink
  Kremer-Grest���f����p�����v�Z�Bstep3�܂Ői�߂�Ǝ���tutorial_4_correlation�p�i5,6,7��tutorial�̓��̓f�[�^���쐬���ăR�s�[����j�̍\���f�[�^�𓾂邱�Ƃ��ł��܂��B�e����MD�B


�� tutorial_4_correlation
  ���͂̎��ԑ��֊֐���p�����ɘa�e�����̌v�Z�B�e����MD�B


�� tutorial_5_G1G2
  �����e����(Storage modulus)�Ƒ����e����(Loss modulus)�̌v�Z�B�ϕ��͑�`�����Ōv�Z�Bpython3��print�`���ɂ��Ă���Bpython3���C���X�g�[�����Ă��Ȃ��ꍇ�́A�R�}���h�v�����v�g�iPowerShell�j��python�Ɠ��͂���ƁAPython3.9����肷���ʂ������B�e����MD�̌v�Z���ʂ�p����B


�� tutorial_6_shear [LJ2]
  ����f�ό`�̌v�Z�i�񕽍t�v�Z�j�B"�Ђ��ݑ��x > (1/Rouse�ɘa����)"�̏ꍇ�A����`���������B�e����MD�B


�� tutorial_7_uni [LJ2]
  ���L���ό`�̌v�Z�i�񕽍t�v�Z�j�B"�Ђ��ݑ��x > (1/Rouse�ɘa����)"�̏ꍇ�A����`���������B�e����MD�B
  �v�Z���r���Ŕj�]���Ă��܂��ꍇ�AUSER-UEFEX ���g��[LJ3]�B


�� ���Ɍ������lammps�Z�~�i�[���m�[�gPC�ōs�����߂ɍ��܂����B���k��̑����搶��gnuplot��python�X�N���v�g��p����Ɛ}�Ŏ��o�I��Rouse�Ƃ̔�r�����邱�Ƃ��ł��܂��B
------------------------------------------------------------------------------
�� References


[LJ1] lammps�u�K��, ���Ɍ�����


[LJ2] https://github.com/t-murash/lammps-hands-on/tree/master/04deform


[LJ3] http://www.cmpt.phys.tohoku.ac.jp/~murasima/


  https://github.com/t-murash/lammps-hands-on


  https://github.com/t-murash/USER-UEFEX


------------------------------------------------------------------------------