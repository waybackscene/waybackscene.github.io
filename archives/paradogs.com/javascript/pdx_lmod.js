var _____WB$wombat$assign$function_____ = function(name) {return (self._wb_wombat && self._wb_wombat.local_init && self._wb_wombat.local_init(name)) || self[name]; };
if (!self.__WB_pmw) { self.__WB_pmw = function(obj) { this.__WB_source = obj; return this; } }
{
  let window = _____WB$wombat$assign$function_____("window");
  let self = _____WB$wombat$assign$function_____("self");
  let document = _____WB$wombat$assign$function_____("document");
  let location = _____WB$wombat$assign$function_____("location");
  let top = _____WB$wombat$assign$function_____("top");
  let parent = _____WB$wombat$assign$function_____("parent");
  let frames = _____WB$wombat$assign$function_____("frames");
  let opener = _____WB$wombat$assign$function_____("opener");

   function initArray() {
      this.length = initArray.arguments.length
      for (var i = 0; i < this.length; i++)
      this[i+1] = initArray.arguments[i]
   }

   var DOWArray = new initArray("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday");
   var MOYArray = new initArray("January","February","March","April","May","June","July","August","September","October","November","December");

   var LastModDate = new Date(document.lastModified);

   document.write("<U>Last modified<\/U>: <B>");
   document.write(MOYArray[(LastModDate.getMonth()+1)]," ");
   document.write(LastModDate.getDate(),", ");
   app = navigator.appName
   if (app == 'Netscape'){
   document.write(LastModDate.getYear()+1900);
   }
   else if (app == 'Microsoft Internet Explorer'){
   document.write(LastModDate.getYear());
   }


}