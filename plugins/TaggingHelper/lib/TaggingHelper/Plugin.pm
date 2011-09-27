# $Id$

package TaggingHelper::Plugin;

use strict;
use MT::Template::Context;
use MT::Plugin;

sub _build_html {
    my $plugin = shift;
    my $html = <<'EOT';
<style type="text/css">

#tagging_helper_container {
    cursor: Default;
    width: 100%;
    text-align: right;
}

#tagging_helper_block {
    cursor: Default;
    text-align: left;
    margin: 10px 0;
    line-height: 1.8em;
}

.taghelper_tag {
    cursor: Default;
    color: #41687b;
    margin: 0 5px;
    white-space: nowrap;
}

.taghelper_tag:hover {
    cursor: Pointer;
    color: #246;
    text-decoration: underline;
}

.taghelper_tag_selected {
    cursor: Default;
    color: #41687b;
    background-color: #bcd;
    margin: 0 5px;
    white-space: nowrap;
}

.taghelper_tag_selected:hover {
    cursor: Pointer;
    color: #246;
    text-decoration: underline;
}

.taghelper_command {
    cursor: Default;
    color: #61889b;
    margin-left: 11px;
}

.taghelper_command:hover {
    cursor: Pointer;
    color: #a2ad00;
}

</style>

<script type="text/javascript">
// simple js syntax, because MT3.3 dosen't have js library.
// just use RegExp.escape; which appear both MT3.3 and MT4. 

var TaggingHelper = new Object();

TaggingHelper.close = function() {
    document.getElementById('tagging_helper_block').style.display = 'none';
}

TaggingHelper.compareStrAscend = function (a, b){
    return a.localeCompare(b);
}

TaggingHelper.compareByCount = function (a, b){
    return tags_json[b] - tags_json[a] || a.localeCompare(b);
}

__getbody

TaggingHelper.open = function (mode) {
    var block = document.getElementById('tagging_helper_block');
    if (block.style.display == 'none') {
        block.style.display = 'block';
    }
    var tags = tags_json;
    var tagary = new Array();
    if (mode == 'abc' || mode == 'count') {
        for (var tag in tags ){
            tagary.push(tag);
        }
    }
    else {
        var body = this.getBody();
        for (var tag in tags ) {
            var exp = new RegExp(RegExp.escape(tag));
            if (exp.test(body)) {
                tagary.push(tag);
            }
        }
    }
    if (mode == 'count')
        tagary.sort(this.compareByCount);
    else
        tagary.sort(this.compareStrAscend);

    var v = document.getElementById('tags').value;
    var taglist = '';
    var table = document.createElement('div');
    table.className = 'taghelper-table';
    for (var i=0; i< tagary.length; i++) {
        var tag = tagary[i];
        var e = document.createElement('span');
        e.onclick   = TaggingHelper.action;
        e.th_tag    = tag;
        e.appendChild( document.createTextNode(tag) );
        var exp = new RegExp("^(.*, ?)?" + RegExp.escape(tag) + "( ?\,.*)?$");
        e.className = (exp.test(v)) ? 'taghelper_tag_selected' : 'taghelper_tag';
        table.appendChild(e);
        table.appendChild( document.createTextNode(' ') );
    }

    while (block.childNodes.length) block.removeChild(block.childNodes.item(0));
    block.appendChild(table);
}

TaggingHelper.action = function (evt) {
    // IE-Firefox compatible
    var e = evt || window.event;
    var a = e.target || e.srcElement;
    var s = a.th_tag;
    
    var v = document.getElementById('tags').value;
    var exp = new RegExp("^(.*, ?)?" + RegExp.escape(s) + "( ?\,.*)?$");
    if (exp.test(v)) {
        v = v.replace(exp, "$1$2");
        if (tag_delim == ',') {
            v = v.replace(/ *, *, */g, ', ');
        }
        else {
            v = v.replace(/  +/g, ' ');
        }
        a.className = 'taghelper_tag';
    }
    else {
        v += (tag_delim == ',' ? ', ' : ' ') + s;
        a.className = 'taghelper_tag_selected';
    }
    v = v.replace(/^[ \,]+/, '');
    v = v.replace(/[ \,]+$/, '');
    document.getElementById('tags').value = v;
}

</script>
<div id="tagging_helper_container">
    <span id="taghelper_abc" onclick="TaggingHelper.open('abc')" class="taghelper_command"><__trans_section component="TaggingHelper"><__trans phrase="alphabetical"></__trans_section></span>
    <span id="taghelper_count" onclick="TaggingHelper.open('count')" class="taghelper_command"><__trans_section component="TaggingHelper"><__trans phrase="frequency"></__trans_section></span>
    <span id="taghelper_match" onclick="TaggingHelper.open('match')" class="taghelper_command"><__trans_section component="TaggingHelper"><__trans phrase="match in body"></__trans_section></span>
    <span id="taghelper_close" onclick="TaggingHelper.close()" class="taghelper_command"><__trans phrase="close"></span>
<div id="tagging_helper_block" style="display: none;"></div>
</div>
EOT

    my $getbody4 = <<'EOT';
TaggingHelper.getBody = function () {
    // for MT 4
    // get both current editting field and hidden input fields.
    // currently i don't care about duplication.
    // but it's very nasty. FIXME!
    return app.editor.getHTML()
         + '\n'
         + document.getElementById('editor-input-content').value
         + '\n'
         + document.getElementById('editor-input-extended').value;
}
EOT

    $html =~ s/__getbody/$getbody4/;
    return $html;
}

sub hdlr_mt4_param {
    my ($eh, $app, $param, $tmpl) = @_;
    my $html = _build_html();
    die 'something wrong...'
        unless UNIVERSAL::isa($tmpl, 'MT::Template');
    my $host_node = $tmpl->getElementById('tags')
        or die 'cannot find tags field in the screen.';
    $host_node->innerHTML($host_node->innerHTML . $html);
    1;
}

sub hdlr_mt5_param {
    my ($eh, $app, $param, $tmpl) = @_;
    my $html = _build_html();
    die 'something wrong...'
        unless UNIVERSAL::isa($tmpl, 'MT::Template');
    my $host_node = $tmpl->getElementById('tags')
        or die 'cannot find tags field in the screen.';
    $host_node->innerHTML($host_node->innerHTML . $html);
    my $blog_id = $app->param('blog_id') or return 1;

    my %terms;
    my $plugin = MT->component("TaggingHelper");
    my $load_blogs = $plugin->get_config_value('load_blogs','blog:'.$blog_id) || '0';
    if ($load_blogs == 0) {
        $terms{'blog_id'}      = $blog_id;
    }
    elsif ($load_blogs == 2) {
        require MT::Blog;
        my $blog = MT::Blog->load( $blog_id );
        my @blog_ids;
        my @blogs = MT::Blog->load({ parent_id => $blog->parent_id }) || '';
        foreach my $sibling (@blogs) {
            push(@blog_ids, $sibling->id);
        }
        if( @blog_ids ){
            $terms{'blog_id'} = \@blog_ids;
        }
    }

    my $page_tags = $plugin->get_config_value('page_tags','blog:'.$blog_id) || '0';
    my $entry_class;
#    if ($page_tags == 1) {
#        $entry_class = [ 'entry', 'page' ];
#    }
#    else {
        $entry_class = 'entry';
#    }

    my $asset_tags = $plugin->get_config_value('asset_tags','blog:'.$blog_id) || '0';
    if ($asset_tags == 1) {
        $terms{'object_datasource'} = [ 'entry', 'asset' ];
    }
    else {
        $terms{'object_datasource'} = [ 'entry' ];
    }

    my $entry_class = 'entry';
    my $iter = MT->model('objecttag')->count_group_by(
        \%terms,
        {   sort      => 'cnt',
            direction => 'ascend',
            group     => ['tag_id'],
            join      => MT::Entry->join_on(
                undef,
                {
                {   class => $entry_class,
                    id    => \'= objecttag_object_id',
                }
            ),
        },
    );
    my %tag_counts;
    while ( my ( $cnt, $id ) = $iter->() ) {
        $tag_counts{$id} = $cnt;
    }
    my %tags = map { $_->name => $tag_counts{ $_->id } } MT->model('tag')->load({ id => [ keys %tag_counts ] });
    my $tags_json = MT::Util::to_json( \%tags );
    $param->{js_include} .= qq{
        <script type="text/javascript">
            var tags_json = $tags_json;
        </script>
    };
    1;
}

sub doLog {
    my ($msg) = @_; 
    return unless defined($msg);
    require MT::Log;
    my $log = MT::Log->new;
    $log->message($msg) ;
    $log->save or die $log->errstr;
}

1;
