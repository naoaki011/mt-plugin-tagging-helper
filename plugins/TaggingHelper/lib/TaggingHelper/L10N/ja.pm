# $Id$

package TaggingHelper::L10N::ja;

use strict;
use base 'TaggingHelper::L10N::en_us';
use vars qw( %Lexicon );

my $mt_version = MT->version_number;

## The following is the translation table.
if ($mt_version >= 6) {
    %Lexicon = (
        'description of TaggingHelper' => '記事編集画面にタグ一覧を表示します。',
        'alphabetical' => 'ABC順',
        'frequency'    => '利用頻度順',
        'match in body' => '本文に一致',
        'Tags Load:' => 'タグの読み込み設定:',
        'Tags Load From:' => 'タグの読み込み元:',
        'Tags Load By:' => 'タグの種類:',
        'Tags Load For:' => 'タグ候補を表示する:',
        'Tags Load for Entry:' => '記事でタグ候補を表示する:',
        'Tags Load for Page:' => 'ウェブページでタグ候補を表示する:',
        'Tags Load for Asset:' => 'アイテムでタグ候補を表示する:',
        'All' => '全体',
        'Sibling' => 'Sibling',
        'Entry Tags' => '記事のタグ',
        'Page Tags' => 'ウェブページのタグ',
        'Asset Tags' => 'アイテムのタグ',
        'Enable Entry' => '記事で表示する',
        'Enable Page' => 'ウェブページで表示する',
        'Enable Asset' => 'アイテムで表示する',
        'akira sawada' => '澤田 哲',
    );
} else {
    %Lexicon = (
        'description of TaggingHelper' => 'ブログ記事編集画面にタグ一覧を表示します。',
        'alphabetical' => 'ABC順',
        'frequency'    => '利用頻度順',
        'match in body' => '本文に一致',
        'Tags Load:' => 'タグの読み込み設定:',
        'Tags Load From:' => 'タグの読み込み元:',
        'Tags Load By:' => 'タグの種類:',
        'Tags Load For:' => 'タグ候補を表示する:',
        'Tags Load for Entry:' => 'ブログ記事でタグ候補を表示する:',
        'Tags Load for Page:' => 'ウェブページでタグ候補を表示する:',
        'Tags Load for Asset:' => 'アイテムでタグ候補を表示する:',
        'All' => '全体',
        'Sibling' => 'Sibling',
        'Entry Tags' => 'ブログ記事のタグ',
        'Page Tags' => 'ウェブページのタグ',
        'Asset Tags' => 'アイテムのタグ',
        'Enable Entry' => 'ブログ記事で表示する',
        'Enable Page' => 'ウェブページで表示する',
        'Enable Asset' => 'アイテムで表示する',
        'akira sawada' => '澤田 哲',
    );
}

1;
