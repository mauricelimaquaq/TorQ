// Get the relevant RDB attributes
.proc.getattributes:{default:`date`tables!(.rdb.rdbpartition[],();tbls:tables[]);
    if[.rdb.subfiltered;
        filters:exec distinct filters from .rdb.subscribesyms;
        idxs:{ss[x;".ds.stripe[[]sym;"]0}each filters;
        /check if rdb is striped by sym
        if[any chk:not null idxs;
            idx:idxs f:first where chk;
            default[`skeysym]:"J"$-1_(15+idx)_filters f;
            ];
        /additional check if striped by time can go here
        /for now assume full day
        default[`skeytime]:00:00:00.000 23:59:59.999;
        ];
    default}

\d .rdb

/- Move a table from one namespace to another
/- this could be used in the end-of-day function to move the heartbeat and logmsg
/- tables out of the top level namespace before the save down, then move them 
/- back when done.
moveandclear:{[fromNS;toNS;tab] 
 if[tab in key fromNS;
  set[` sv (toNS;tab);0#fromNS tab];
  eval(!;enlist fromNS;();0b;enlist enlist tab)]}
