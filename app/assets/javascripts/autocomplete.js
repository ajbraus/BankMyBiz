$("#postTags").tagit({
  availableTags: ["Small Business Loan", 
                  "Business Loan", 
                  "Private Equity", 
                  "Growth",
                  "Startup Funding",
                  "How To",
                  "Capital",
                  "Banking Tips",
                  
                  // PRODUCTS
                  "Term Loan", 
                  "Line of Credit", 
                  "SBA Loan", 
                  "Factoring",
                  "Cash Advance",
                  "Merchant Cash Advance",
                  "Revenue Based Financing",
                  "Asset Based Financing",
                  "Community Development Funding",
                  "Grants",
                  "Crowd Funding (Rewards)",
                  "Crowd Funding (Equity)",
                  "Venture Capital",
                  "Angel Investment"                    
                  ],
    allowSpaces: true
});

$('#followTags').autocomplete({
  source: "/tags",
  minLength: 2
});