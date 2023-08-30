var input = `201601|11125.00
201602|8675.00
201603|12212.00
201604|10917.00
201605|12599.00
201606|10443.00
201607|11290.00
201608|1388.00
201609|7365.00
201610|10610.00
201611|15078.00
201612|16057.00
201701|10477.00
201702|7514.00
201703|10107.00
201704|8770.00
201705|6277.00
201706|17009.00
201707|14492.00
NULL|0.00`;
var S = ["|",","];

function jobInputSplit ( input_str ) {
    //scrivo il codice di split
    return input_str.split('\n');
}
function keyVal(k,v){  return k+S[0]+v }

function jobMap ( V_In_Map ) {
    
    return V_In_Map.map(function(item){
        //scrivo il codice di map
        var data = item.split("|")[0]
        var anno = data.slice(0,4);
        var mese = data.slice(4,6);
        var media = item.split("|")[1]
        var chiave= anno;
        var valore = mese+"-"+media;
        return keyVal(chiave, valore);
    });
}

function jobReduce ( K_In_Reduce_V_In_Reduce ) {
    
    return K_In_Reduce_V_In_Reduce.map(function (items){
        var K_In_Reduce = items.split(S[0])[0];
    var V_In_Reduce = items.split(S[0])[1].split(S[1]);
    //scrivo il codice di split
    var mese_massimo;
    var Reduce = V_In_Reduce.reduce(function (massimo, item,) {
        var mese_item = item.split("-")[0];
        var media_item = item.split("-")[1];
        if((parseFloat(media_item)>parseFloat(massimo))||massimo==0){
            mese_massimo = mese_item;
            return media_item;
        } else {
            return massimo;
        }   
    },0);  
    var k_out = K_In_Reduce;
        var v_out = mese_massimo+"-"+ Reduce;
        return keyVal (k_out,v_out);
    });
}

function merge(v){
    new_v = []
    conc = ''
    for(var i=1; i<=v.length; i++){
        d = v[i-1].split(S[0])
        if(conc.length==0) { conc+= d[1]+S[1]+' '}
        if(i!=v.length){
             d1 = v[i].split(S[0])
             if(d[0] != d1[0]){
                   new_v.push(d[0]+S[0]+conc.substring(0,conc.length-2))
                   conc = ''
                }else{
                   conc+= d1[1]+S[1]+' '
             }
           }else{
             new_v.push(d[0]+S[0]+conc.substring(0,conc.length-2))
        }
     }
     return new_v
 }



var splitted = jobInputSplit(input);
console.log(splitted);
var mapped = jobMap(splitted);
console.log(mapped);
var merged = merge(mapped.sort());
console.log(merged);
var reduced = jobReduce(merged.sort());
console.log(reduced);