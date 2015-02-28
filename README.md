Twitterユーザの位置推定に関する研究（A research related to location estimation for Twitter user）
==
本研究では、Twitterから位置情報付きのランダムツイートを収集し、語彙と場所との関連性を調べ、ユーザの使用語彙に注目して位置推定を行った。推定には全ての語彙を使用するより、場所に関連性が強い特徴語彙を使用した方が推定精度が良いことが検証実験でわかった。この様な研究は以前にもされているが、本研究の特徴として：
* 研究対象が日本、日本語
* 位置推定モデルの改善（検証実験で確認）
* 外部情報の利用（降雨画像情報）

がある。ユーザは雨についてツイートを発信するとユーザはその時間帯に雨が降っている地域にいる可能性が高いと考えた。以下に本レポジトリについて簡単に説明する

説明
==

##after_the_defence_asobi
研究が終わった後に、遊びとして研究室の人たちの位置推定を行ってみた。その為に使用したプログラム

##analyzer
語彙の抽出など、解析に使われるプログラム

##basic_twitter_access
ライブラリなどを使わず、Ruby言語の基本的なコードでTwitterにアクセスできるプログラム

##cronjob_backup
データ収集時に外付けHDDに毎日バックアップ取る、cronjobで動かすプログラム

##data_cleaners_and_converters
データクリーニング、変換用のプログラム

##data_collector
データ収集プログラム

##estimation_result_data
検証実験の結果

##estimators
様々な位置推定プログラム

##learning_ruby
ruby言語の学び

##map_creator
データを地図にプロットするプログラム

##more_about_twitter_ruby
Ruby言語向けの[https://github.com/sferik/twitter][twitter]ライブラリの簡単な使用例

##rate_limit_checker
TwitterのREST APIには使用制限があり、その為の現在の使用状況を確認するプログラム

データについて
==
本研究で使ったデータはサイズが大きいため、レポには入れていない。





