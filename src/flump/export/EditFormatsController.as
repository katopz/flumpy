//
// flump-exporter

package flump.export {

import com.threerings.util.lists.ArrayList;

import flash.events.MouseEvent;

import org.osflash.signals.Signal;

public class EditFormatsController
{
    public const formatsChanged :Signal = new Signal();

    public function EditFormatsController (conf :ProjectConf) {
       
    }

    public function show () :void {
        _win.orderToFront();
    }

    public function get closed () :Boolean {
        return _win.closed;
    }
    protected var _win :Object;
}
}