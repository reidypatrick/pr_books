custom_css <- "
  body {
    background-color: #121212;
    color: #e0e0e0;
  }
  .book-container {
    border: 2px solid #333;
    border-radius: 10px;
    padding: 15px;
    margin-bottom: 20px;
    background-color: #1e1e1e;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
  }
  .book-container:hover {
    box-shadow: 0 8px 16px rgba(0, 0, 0, 0.5);
  }
  .book-cover {
    text-align: left;
    margin-bottom: 15px;
  }
  .book-details {
    padding-left: 20px;
  }
  .book-title {
    font-size: 1.5em;
    font-weight: bold;
    color: #ffffff;
  }
  .book-author {
    font-size: 1.2em;
    color: #bbbbbb;
  }
  .book-year {
    font-size: 1em;
    color: #999999;
  }
  .progress-bar-container {
    margin-top: 10px;
    padding-left: 35px;
  }
  .progress-bar {
    background-color: #333;
  }
  .progress-bar .progress {
    background-color: #4caf50;
  }
  .shiny-input-container {
    color: #16151c;
    padding-left: 0px;
  }
  .shiny-input-container label {
    color: #e0e0e0;
    text-align: left;
  }
  .shiny-numeric-input input {
    background-color: #333;
    color: #e0e0e0;
    border: 1px solid #555;
    text-align: left;
  }
  .tabsetPanel {
    background-color: #1e1e1e;
    border: 1px solid #333;
  }
  .nav-tabs > li > a {
    color: #e0e0e0;
    background-color: #333;
    border: 1px solid #555;
  }
  .nav-tabs > li.active > a {
    color: #ffffff;
    background-color: #1e1e1e;
    border: 1px solid #555;
  }
  .modal-content {
    background-color: #2d2d2d; /* Dark gray background */
    border-radius: 15px; /* Rounded corners */
    border: 2px solid #444; /* Darker gray border */
    color: #ffffff; /* White text */
  }
  .modal-header {
    background-color: #1a1a1a; /* Darker gray header */
    color: #ffffff; /* White text */
    border-top-left-radius: 15px; /* Rounded corners for header */
    border-top-right-radius: 15px;
    border-bottom: 1px solid #444; /* Separator line */
  }
  .modal-body {
    font-size: 16px; /* Larger font size */
    color: #ffffff; /* White text */
  }
  .modal-footer {
    background-color: #2d2d2d; /* Dark gray footer */
    border-bottom-left-radius: 15px; /* Rounded corners for footer */
    border-bottom-right-radius: 15px;
    border-top: 1px solid #444; /* Separator line */
  }
  .edit-actions{
    padding-bottom: 2px;
  }
  .btn-primary {
    background-color: #555; /* Medium gray button */
    border-color: ##1e1e1e;
    color: #ffffff; /* White text */
    text-align: left;
  }
  .btn-primary:hover {
    background-color: #666; /* Lighter gray on hover */
    border-color: ##1e1e1e;
  }
  .btn-default {
    background-color: #444; /* Dark gray button */
    border-color: ##1e1e1e;
    color: #ffffff; /* White text */
    text-align: left;
  }
  .btn-default:hover {
    background-color: #555; /* Medium gray on hover */
    border-color: ##1e1e1e;
  }
  input[type='text'], 
  input[type='number'] {
    background-color: #333333; /* Dark gray background */
    color: #ffffff; /* White text */
    border: 1px solid #555555; /* Medium gray border */
    border-radius: 5px; /* Rounded corners */
  }
  input[type='text']:focus, 
  input[type='number']:focus {
    border-color: #777777; /* Lighter gray border on focus */
    outline: none; /* Remove default outline */
  }
  .dark-select .selectize-control.single .selectize-input {
    background-color: #333333; /* Dark gray background */
    color: #ffffff; /* White text */
    border: 1px solid #555555; /* Medium gray border */
    border-radius: 5px; /* Rounded corners */
    padding: 5px 10px; /* Padding for better appearance */
  }
  .dark-select .selectize-control.single .selectize-input input {
    color: #ffffff; /* White text for the selected value */
  }
  .dark-select .selectize-control.single .selectize-input.focus {
    background-color: #333333; /* Dark gray background when focused */
    border-color: #777777; /* Lighter gray border when focused */
    box-shadow: none; /* Remove default focus shadow */
  }
  .dark-select .selectize-control.single .selectize-input:after {
    border-color: #ffffff transparent transparent transparent; /* White dropdown arrow */
  }
  .dark-select .selectize-control.single .selectize-input.dropdown-active:after {
    border-color: transparent transparent #ffffff transparent; /* White dropdown arrow when active */
  }
  .dark-select .selectize-dropdown {
    background-color: #333333; /* Dark gray background */
    color: #ffffff; /* White text */
    border: 1px solid #555555; /* Medium gray border */
    border-radius: 5px; /* Rounded corners */
  }
  .dark-select .selectize-dropdown .option {
    background-color: #333333; /* Dark gray background */
    color: #ffffff; /* White text */
  }
  .dark-select .selectize-dropdown .option:hover {
    background-color: #444444; /* Lighter gray on hover */
  }
  .dark-select .selectize-dropdown .active {
    background-color: #555555; /* Even lighter gray for active option */
    color: #ffffff; /* White text */
  }
  .activity-container {
        display: flex;
        flex-direction: row;
        gap: 10px;
      }
  .y-axis-labels {
    display: flex;
    flex-direction: column;
    gap: 0px;
    justify-content: space-between;
    padding-top: 0px;  /* Align labels with cells */
  }
  .y-axis-label {
    height: 15px;
    text-align: right;
    padding-right: 5px;
    font-size: 12px;
  }
  .activity-grid {
    display: flex;
    flex-direction: row;
    gap: 2px;
  }
  .activity-column {
    display: flex;
    flex-direction: column;
    gap: 2px;
  }
  .activity-cell {
    width: 15px;
    height: 15px;
    background-color: #121212;
    border-radius: 3px;
  }
  .activity-cell:hover {
    border: 1px solid black;
}
"
