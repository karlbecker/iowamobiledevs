function ProgramListAPI($, ko) {

    // Context Variables
    var viewElement = null;
    var viewModel = null;

    var self = this;

    var titleAlphaSort = function(a, b) {
        if(a.title() == b.title())
            return 0;

        return (a.title() > b.title()) ? 1 : -1;
    };

    // Init Method
    this.init = function (element, model) {
        
        viewElement = $(element);

        viewModel = ko.mapping.fromJS(model);

        viewModel.programList.sort(titleAlphaSort);

        viewModel.genreFilter = ko.observable();

        viewModel.filteredProgramList = ko.computed(function() {

            if (!this.genreFilter()) {
                return this.programList();
            } else {
                return ko.utils.arrayFilter(this.programList(), function (item) { return item.genre() == this.genreFilter(); }.bind(viewModel));
            }

        }, viewModel);

        viewModel.showDetails = function (item) {
            self.executeCommand("details", ko.toJSON(item));
        }.bind(this);

        viewModel.setReminder = function (item) {
            self.executeCommand("reminder", ko.toJSON(item));
        }.bind(this);

        ko.applyBindings(viewModel, viewElement[0]);
    };

    // API Methods

    this.toggleDescriptions = function(visible) {
        viewModel.showDescriptions(visible);
    };

    this.getGenres = function(returnJSON) {

        var result = [];

        for (var i = 0; i < viewModel.programList().length; i++) {
            var found = false;
            var genre = viewModel.programList()[i].genre();
            for (var j = 0; j < result.length; j++) {
                if (result[j] == genre) {
                    found = true;
                    break;
                }
            }
            if (!found) result.push(genre);
        }

        return returnJSON ? ko.toJSON(result) : result;
    };

    this.setGenreFilter = function(genre) {
        viewModel.genreFilter(genre);

        return viewModel.genreFilter();
    };

    this.executeCommand = function (command, commandArgsJSON) {
        // Don't use a hash tag
        document.location = '/command/' + command + '?' + escape(commandArgsJSON);
    };


}