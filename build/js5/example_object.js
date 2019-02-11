'use strict';

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

// Generated by CoffeeScript 2.3.2
(function () {
  // example_object.coffee
  var Stack, Stack_Stub, WS_RMI_Stub;

  WS_RMI_Stub = WS_RMI_Stub || require('./ws_rmi_client.coffee').WS_RMI_Stub;

  Stack = function () {
    // note that the object must have an id in order to
    // register and operate with the rmi server

    function Stack(id) {
      _classCallCheck(this, Stack);

      this.push = this.push.bind(this);
      this.pop = this.pop.bind(this);
      this.id = id;
      this.stack = [];
    }

    _createClass(Stack, [{
      key: 'push',
      value: function push(x, cb) {
        this.stack.push(x);
        console.log(this.stack);
        return cb(true);
      }
    }, {
      key: 'pop',
      value: function pop(cb) {
        cb(this.stack.pop());
        return console.log(this.stack);
      }
    }]);

    return Stack;
  }();

  Stack_Stub = function () {
    var Stack_Stub = function (_WS_RMI_Stub) {
      _inherits(Stack_Stub, _WS_RMI_Stub);

      function Stack_Stub() {
        _classCallCheck(this, Stack_Stub);

        return _possibleConstructorReturn(this, (Stack_Stub.__proto__ || Object.getPrototypeOf(Stack_Stub)).apply(this, arguments));
      }

      return Stack_Stub;
    }(WS_RMI_Stub);

    ;

    Stack_Stub.add_stub('push');

    Stack_Stub.add_stub('pop');

    return Stack_Stub;
  }.call(this);

  if (typeof window !== "undefined" && window !== null) {} else {
    exports.Stack = Stack;
    exports.Stack_Stub = Stack_Stub;
  }
}).call(undefined);

//# sourceURL=/home/carruth/git/ws_rmi/build/coffee/example_object.coffee