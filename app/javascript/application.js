// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "jquery"

// Make jQuery available globally
window.$ = window.jQuery = jQuery

// Import search functionality
import "./search"