# lammps_education_LJ_win


# Note: This is test version. (Please, you would develop them)


The elements in the input and output are tentative.


The Kremer-Grest model is used in macromolecules.


------------------------------------------------------------------------------
■ lammps

□ インストール方法
1. http://packages.lammps.org/windows.html のHPで"64-bit Windows download area"をクリックする
2. LAMMPS-64bit-18Jun2019.exe をダウンロードして解凍する
3. ディフォルトの設定のまま最後まで進めばよい
以上で lammps のダウンロードと設定は完了です


□ 描画ソフト
 ・gnuplot（http://www.gnuplot.info/）
  http://www.yamamo10.jp/yamamoto/comp/gnuplot/inst_win/index.php
・Ovito（https://www.ovito.org/windows-downloads/）
※ web上に情報がありますので、お手数をおかけしますが、そちらをご参照ください
※ gnuplotのインストールと環境設定 (Edit: Dec/11/2020)
1. gnuplot - Browse /gnuplot at SourceForge.net から gp528-win64-mingw.exe を得る
  gp528-win64-mingw.exe をダブルクリック。設定はディフォルトのままでよい
2. コントロール パネル > システムとセキュリティ > システム
3. システムの環境設定 > 環境変数（N）... > システム環境変数（S）のPath > 編集（I）... > 新規（N）> C:\Program Files\gnuplot\bin を追加する > OK > OK
------------------------------------------------------------------------------
■ 分子動力学シミュレーション


□ 入力ファイルのダウンロード
  by-student-2017 の lammps_education_LJ_win (https://github.com/by-student-2017/lammps_education_LJ_win.git) から入力ファイルをダウンロードして解凍する。右側の[Clone or download]をクリックしていただくと Download ZIP が表示されます


□ シミュレーションの実行
1. 各種のフォルダの中にある run.bat をダブルクリックすれば計算が走る
2. cfg を Ovito で開けば構造が得られる
3. plot と記載のあるファイルをダブルクリックすれば図が得られる
  ※ 温度が目的の値になっているか、エネルギーが一定の値になっているかを確認してみてください
※ 以上の手順は、data.inにある原子の情報、そして、in.lmpのポテンシャルと出力の原子の情報を書きかえれば他の材料でも同様に計算が可能です（Avogadroなどのフリーソフトを用いて構造のファイル（data.in）を作られる方もいます）


□ tutorial_1_colloid
  コロイドの計算。2dが2次元、3dが3次元での計算。


□ tutorial_2_micelle_Kremer-Grest-model
  Kremer-Grestモデルを用いたミセルの計算。


□ tutorial_3_crosslink
  Kremer-Grestモデルを用いた計算。step3まで進めると次のtutorial_4_correlation用の構造データを得ることができます。


□ tutorial_4_correlation
  応力の時間相関関数を用いた緩和弾性率の計算。


※ 兵庫県立大のlammpsセミナーをノートPCで行うために作りました。東北大の村島先生のgnuplotやpythonスクリプトを用いると図で視覚的にRouseとの比較をすることができます。
------------------------------------------------------------------------------
■ References


[LJ1] lammps セミナー, 兵庫県立大


[LJ2] http://www.cmpt.phys.tohoku.ac.jp/~murasima/


  https://github.com/t-murash/lammps-hands-on


  https://github.com/t-murash/USER-UEFEX
------------------------------------------------------------------------------