//
// Flump - Copyright 2013 Flump Authors

package flump.export {

import flash.filesystem.File;

import org.osflash.signals.Signal;

public class DirChooser
{
    public const changed :Signal = new Signal(File);

    public function DirChooser (initial :File)
    {
		changed.dispatch(dir);
        dir = initial;
    }

    /** The selected directory or null if none has been selected. */
    public function get dir () :File { return _dir == null ? null : new File(_dir); }

    public function set dir (dir :File) :void {
        if (dir != null) {
            _dir = dir.nativePath;
        } else {
            _dir = null;
        }
    }

    protected var _dir :String;
}
}
