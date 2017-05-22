
/*======================================================================*\
  Q2hlZXJzIQ==
\*======================================================================*/

// we need to check for 'undefined' type first, otherwise the other expression will trigger a 'not defined' error
if (typeof (NAMESPACE) == 'undefined' || NAMESPACE == null) {
    NAMESPACE = {};

    // We define it outside resource() because it's supposed to be a mutual variable for all instances.
    // Otherwise it would work as a separate local variable of each instance, thus the function would
    // allocate a new resource every time, even for same IDs.
    var _all_ids = new Array();

    // Creates an object that allocates a new or references an
    // existing very expensive resource associated with `id`
    var resource = function (id) {
        // Private data
        var _closed = false;
        // Note: _closed is defined and it's set in close(), but it's never actually used. Was it designed for a bigger purpose?
        var _id = id;
        var _expensive_resource = null;

        // Public data
        var persona = {
        };

        // Public methods
        var getExpensiveResource = function () {
            return _expensive_resource;
        }
        
        persona.getExpensiveResource = getExpensiveResource;

        var getId = function () {
            return _id;
        }
        
        persona.getId = getId;

        var close = function () {
            delete _all_ids[_id];
            _expensive_resource = null; // Otherwise the allocated resource would still sit in memory.
            // If all resource instances with same ID get closed then the allocated resource won't be referenced by
            // any variable and the garbage collector will free the memory taken by the very expensive resource.

            _closed = true; // It's a private variable, 'this._closed' would refer to a public one
        }

        persona.close = close;
        
        // Private methods
        function _lookupOrCreateExpensiveResourceById(id) {
            var _expensive_resource = _all_ids[id];
            // Added 'var' to avoid the closure that apparently wasn't meant to be here,
            // because this result is later returned from the function as a result.
            // You either return a local var as a result or assign the property directly via a closure, why doing both?
            
            if (_expensive_resource == null) {
                // Just pretend for the sake of this example
                _expensive_resource = {
                    value: "I'm a very expensive resource associated with ID " + id
                };

                _all_ids[id] = _expensive_resource;
            }
            
            return _expensive_resource;
        }
        
        // Initialization
        _expensive_resource = _lookupOrCreateExpensiveResourceById(id);
        
        return persona;
    }

    NAMESPACE.resource = resource;
}