
function jobInputSplit ( input_str ) {
    return input_str.split('\n');
}
function jobMap ( V_In_Map ) {
    
    return V_In_Map.map(function(item){
        //scrivo il codice di map
        var tipoOrdine = item.split(",")[0]
        var data = item.split(",")[1]
        var costo = item.split(",")[2]

        var chiave;
        var valore;
        if(tipoOrdine === "FATTURA" || tipoOrdine === "RICEVUTA"){
            chiave = data.slice(0,6);
            valore = costo;
        }
        else
        {
            chiave = "NULL";
            valore = 0;
        }
        return keyVal(chiave, valore);
    });
}

function jobReduce ( K_In_Reduce_V_In_Reduce ) {
    
    return K_In_Reduce_V_In_Reduce.map(function (items){
        var K_In_Reduce = items.split(S[0])[0];
        var V_In_Reduce = items.split(S[0])[1].split(S[1]);
        //scrivo il codice di split
        var Reduce = V_In_Reduce.reduce(function (accumulator, item,) {
            if(K_In_Reduce !== "NULL"){
                return parseInt(accumulator) + parseInt(item);
            }
            return 0;
        },0);  
        var k_out = K_In_Reduce;
        var v_out = (Reduce/V_In_Reduce.length).toFixed(2)  ;
        return keyVal (k_out,v_out);
    });
}