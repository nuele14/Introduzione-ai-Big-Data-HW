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
    //scrivo il codice di reduce
    var mese_minimo;
    var Reduce = V_In_Reduce.reduce(function (minimo, item,) {
        var mese_item = item.split("-")[0];
        var media_item = item.split("-")[1];
        if((parseFloat(media_item)<parseFloat(minimo))||minimo==0){
            mese_minimo = mese_item;
            return media_item;
        } else {
            return minimo;
        }   
    },0);  
    var k_out = K_In_Reduce;
        var v_out = mese_minimo+"-"+ Reduce;
        return keyVal (k_out,v_out);
    });
}