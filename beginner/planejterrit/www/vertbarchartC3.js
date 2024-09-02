 // This isn't strictly necessary, but it's good JavaScript hygiene.
//(function() {

var binding = new Shiny.OutputBinding();

binding.find = function(scope) {
  // For the given scope, return the set of elements that belong to
  // this binding.
  return $(scope).find(".vertbarchartC3");
};

binding.renderValue = function(el, data) {
  // This function will be called every time we receive new output
  // values for a line chart from Shiny. The "el" argument is the
  // div for this particular chart.
  
  var $el = $(el);
  
  //ajustando os dados aos parâmetros do gráfico (01-fev-2019)
  var teste = data;
  Object.keys(teste).forEach(function(key) {
  teste[key].unshift(key);
});
  
  var result = Object.keys(teste).map(function(key) {
  return teste[key];
});
  //console.log(result[1]);
 //para as categorias do eixo x
  var nome_x = teste['.id'];
 // nome_x = [nome_x[0],nome_x[1],nome_x[3],nome_x[2],nome_x[4]];
  nome_x.shift();

  //console.log(nome_x);
/*
 var empty = Array();
 for(i = 0, i = result.length)
 
  var x = [
            ['data1', 30, 200, 100, 400, 150, 250],
            ['data2', 130, 100, 140, 200, 150, 50]
        ];
  console.log(x);*/
  result = result[1];
  console.log(result);
 /*These lines are all chart setup.  Pick and choose which chart features you want to utilize. */
  var chart = c3.generate({
    bindto: el,
    data: {
        columns: [result],
        type: 'bar'
    },
    axis: {
      rotated: true,
      x: {
        type: 'category',
        categories: nome_x,
      }
    },
    zoom: {
      enabled: true,
      rescale: true
    }
});

return chart

}; //render.binding
 /*console.log(binding);*/


// Tell Shiny about our new output binding
Shiny.outputBindings.register(binding, "shinyjs.vertbarchartC3");
//}) //endfunction

