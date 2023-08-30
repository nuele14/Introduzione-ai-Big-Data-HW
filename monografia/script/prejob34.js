function jobReduce ( K_In_Reduce_V_In_Reduce ) {
    
    return K_In_Reduce_V_In_Reduce.map(function (items){
        var K_In_Reduce = items.split(S[0])[0];
    var V_In_Reduce = items.split(S[0])[1].split(S[1]);
    //scrivo il codice di reduce
    var Reduce = V_In_Reduce.reduce(function (accumulator, item,) {
             return parseInt(accumulator) + parseInt(item);       
    },0);  
    var k_out = K_In_Reduce;
        var v_out = Reduce.toFixed(2);
        return keyVal (k_out,v_out);
    });
}