This is a minimal example of Parent - Child rmarkdown using dataset Diamond

# Get Started
Open the sample_parent.Rmd and click on "knitr"

# Problem Description
There are 2 problems with this example.
  1. Different indentation of YAML header lead to different results. 
   By Default, runtime option in the YAML header of parent.rmd is not indented. 
   
   
    ---
    title: "Hello Prerendered Shiny"
    output:
      html_document:
        theme: cosmo
        fig_caption: yes
        keep_md: no
        number_sections: no
        toc: yes
        toc_depth: 5
        toc_float:
          collapsed: true
    runtime: shiny_prerendered
    ---
    
    
  This will lead to an output that: 
  
  
  a).Only the final chunk "Diamond color - J - Ideal Cut" has a DT detail table. 
  
  b).This detail table doesn't react to "save" button. (i.e. hitting save will not save any edited result to ./input/cache/diamond folder)
  
  c).When inspecting the output html file, there're error messages: 
  
    "Uncaught TypeError: a.indexOf is not a function" I guess it's indexing for the output id but couldn't find it.
  
  
  2. But if we indent "runtime: shiny_prerendred" in the YAML header in parent.rmd by 2 digits:
    
    ---
    title: "Hello Prerendered Shiny"
    output:
      html_document:
        theme: cosmo
        fig_caption: yes
        keep_md: no
        number_sections: no
        toc: yes
        toc_depth: 5
        toc_float:
          collapsed: true
      runtime: shiny_prerendered
    ---
    
    The output will change:
    
    a). On first knit, all DT object will show up
    b). Save button still don't work
    c). Table of Content will lose function
    d). On second knit or refresh page, all DT will disappear. 
    e). Inspecting html error message: 
    
      Uncaught TypeError: channel.execCallbacks[message.id] is not a function
      at QWebChannel.handleResponse (userscript:qwebchannel:137:42)
      at Object.QWebChannel.transport.onmessage (userscript:qwebchannel:86:25)
      
      
     I'm only making notes of symptons. I don't know the root cause. 
     
  3. The "save" button work in a stand-alone example: see "test_save_button.R" 
