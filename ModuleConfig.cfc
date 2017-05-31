/*
 * Copyright 2016 Joel Tobey <joeltobey@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * @author Joel Tobey
 */
component {

    // Module Properties
    this.title              = "cfboom-mail";
    this.author             = "Joel Tobey";
    this.webURL             = "";
    this.description        = "cfboom mail services.";
    this.version            = "1.0.0";
    // If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
    this.viewParentLookup   = true;
    // If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
    this.layoutParentLookup = true;
    // Module Entry Point
    this.entryPoint         = "cfboom/mail";
    // Model Namespace
    this.modelNamespace     = "cfboomMail";
    // CF Mapping
    this.cfmapping          = "cfboom/mail";
    // Auto-map models
    this.autoMapModels      = true;
    // Module Dependencies
    this.dependencies       = [ "cfboom-lang" ];

    function configure(){

        // parent settings
        parentSettings = {};

        // module settings - stored in modules.name.settings
        settings = {
            "debugEmail" = "your.email@mycompany.com",
            "noReplyEmail" = "no_reply@mycompany.com"
        };

        // Layout Settings
        layoutSettings = {
            defaultLayout = ""
        };

        // datasources
        datasources = {};

        // SES Routes
        routes = [];

        // Custom Declared Points
        interceptorSettings = {
            customInterceptionPoints = ""
        };

        // Custom Declared Interceptors
        interceptors = [];

        // Binder Mappings
        // binder.map("Alias").to("#moduleMapping#.model.MyService");
    }

    /**
     * Fired when the module is registered and activated.
     */
    function onLoad(){}

    /**
     * Fired when the module is unregistered and unloaded
     */
    function onUnload(){}

}