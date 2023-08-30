function jobReduce ( K_In_Reduce_V_In_Reduce ) {
    
    return K_In_Reduce_V_In_Reduce.map(function (items){
        var K_In_Reduce = items.split(S[0])[0];
    var V_In_Reduce = items.split(S[0])[1].split(S[1]);
    //scrivo il codice di reduce
    var totale = V_In_Reduce.reduce(function (accumulator, item,) {
             return parseInt(accumulator) + parseInt(item);       
    },0); 
    var media = totale/V_In_Reduce.length;
    console.log(media);
    var scarti_quadratici = V_In_Reduce.map( item =>
          Math.pow(parseInt(media) - parseInt(item),2)
    );
    var scarto_quadratico_medio = scarti_quadratici.reduce(function (accumulator, item,) {
                return parseInt(accumulator) + parseInt(item);
    },0)/scarti_quadratici.length;   
    console.log(scarto_quadratico_medio);
    var k_out = K_In_Reduce;
        var v_out = scarto_quadratico_medio.toFixed(2) ;
        return keyVal (k_out,v_out);
    });
}