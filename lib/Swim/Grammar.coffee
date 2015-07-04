require 'Pegex/Grammar'

class (global.Swim?=->).Grammar extends Pegex.Grammar
  file: '../swim-pm/ext/swim-pgx/swim.pgx'

  start_rules: [
    'document',
    'text-markup',
    'block-list-item',
  ]

  make_tree: ->
    {
       "+grammar" : "swim",
       "+toprule" : "document",
       "+version" : "0.0.2",
       "block_blank" : {
          ".ref" : "line_blank"
       },
       "block_code" : {
          ".rgx" : "\\\\{3}\\r?\\n((?:.*(?:\\r?\\n|\\z))*?)\\\\{3}(?:\\r?\\n|\\z)(?:\\ +(?:\\r?\\n|\\z)|\\r?\\n)?"
       },
       "block_comment" : {
          ".rgx" : "\\#{3}\\r?\\n((?:.*(?:\\r?\\n|\\z))*?)\\#{3}(?:\\r?\\n|\\z)(?:\\ +(?:\\r?\\n|\\z)|\\r?\\n)?"
       },
       "block_func" : {
          ".rgx" : "<<<\\ *([\\w\\-]+)\\ *(?:(.*?)\\ *|\\r?\\n((?:.*\\r?\\n)*?))\\>\\>\\>\\r?\\n"
       },
       "block_head" : {
          ".rgx" : "(={1,4})\\ +(?:(.+?)\\ +=+(?:\\r?\\n|\\z)|(.+\\r?\\n(?:[^\\s].*\\r?\\n)*[^\\s].*?)\\ +=+(?:\\r?\\n|\\z)|(.+\\r?\\n(?:[^\\s].*\\r?\\n)*)(?=[\\ \\*=\\#]|(?:\\r?\\n|\\z)))(?:\\ +(?:\\r?\\n|\\z)|\\r?\\n)?"
       },
       "block_list" : {
          ".any" : [
             {
                ".ref" : "block_list_bullet"
             },
             {
                ".ref" : "block_list_number"
             },
             {
                ".ref" : "block_list_data"
             }
          ]
       },
       "block_list_bullet" : {
          ".rgx" : "(\\*\\ .*(?:\\r?\\n|\\z)(?:\\*\\ .*(?:\\r?\\n|\\z)|(?:\\ +(?:\\r?\\n|\\z)|\\r?\\n)|\\ {2}.*(?:\\r?\\n|\\z))*)"
       },
       "block_list_data" : {
          ".rgx" : "(\\-\\ .*(?:\\r?\\n|\\z)(?:\\-\\ .*(?:\\r?\\n|\\z)|(?:\\ +(?:\\r?\\n|\\z)|\\r?\\n)|\\ {2}.*(?:\\r?\\n|\\z))*)"
       },
       "block_list_number" : {
          ".rgx" : "(\\+\\ .*(?:\\r?\\n|\\z)(?:\\+\\ .*(?:\\r?\\n|\\z)|(?:\\ +(?:\\r?\\n|\\z)|\\r?\\n)|\\ {2}.*(?:\\r?\\n|\\z))*)"
       },
       "block_meta" : {
          ".rgx" : "\\-{3}\\r?\\n([\\s\\S]*?\\r?\\n|)\\.{3}(?:\\r?\\n|\\z)(?:\\ +(?:\\r?\\n|\\z)|\\r?\\n)?"
       },
       "block_para" : {
          ".rgx" : "((?:(?![\\ \\*=\\#\\n]\\ ).*\\S.*(?:\\r?\\n|\\z))+)(?:\\ +(?:\\r?\\n|\\z)|\\r?\\n)?"
       },
       "block_pref" : {
          ".rgx" : "((?:(?:\\ +(?:\\r?\\n|\\z)|\\r?\\n)*\\ \\ .*(?:\\r?\\n|\\z))+)(?:\\ +(?:\\r?\\n|\\z)|\\r?\\n)?"
       },
       "block_rule" : {
          ".rgx" : "\\-{4}(?:\\r?\\n|\\z)(?:\\ +(?:\\r?\\n|\\z)|\\r?\\n)?"
       },
       "block_title" : {
          ".rgx" : "((?:(?![\\ \\*=\\#\\n]\\ ).*\\S.*(?:\\r?\\n|\\z)))={3,}\\r?\\n(?:(?:\\ +(?:\\r?\\n|\\z)|\\r?\\n)((?:(?![\\ \\*=\\#\\n]\\ ).*\\S.*(?:\\r?\\n|\\z)))(?=(?:\\ +(?:\\r?\\n|\\z)|\\r?\\n)))?(?:\\ +(?:\\r?\\n|\\z)|\\r?\\n)?"
       },
       "block_top" : {
          ".any" : [
             {
                ".ref" : "block_func"
             },
             {
                ".ref" : "block_blank"
             },
             {
                ".ref" : "block_comment"
             },
             {
                ".ref" : "line_comment"
             },
             {
                ".ref" : "block_rule"
             },
             {
                ".ref" : "block_meta"
             },
             {
                ".ref" : "block_head"
             },
             {
                ".ref" : "block_code"
             },
             {
                ".ref" : "block_pref"
             },
             {
                ".ref" : "block_list"
             },
             {
                ".ref" : "block_title"
             },
             {
                ".ref" : "block_verse"
             },
             {
                ".ref" : "block_para"
             }
          ]
       },
       "block_verse" : {
          ".rgx" : "\\.\\r?\\n((?:(?![\\ \\*=\\#\\n]\\ ).*\\S.*(?:\\r?\\n|\\z))+)(?:\\ +(?:\\r?\\n|\\z)|\\r?\\n)?"
       },
       "document" : {
          "+min" : 0,
          ".ref" : "block_top"
       },
       "line_blank" : {
          ".rgx" : "(?:\\ +(?:\\r?\\n|\\z)|\\r?\\n)"
       },
       "line_comment" : {
          ".rgx" : "\\#\\ ?(.*?)(?:\\r?\\n|\\z)(?:\\ +(?:\\r?\\n|\\z)|\\r?\\n)?"
       }
    }
