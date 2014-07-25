module ApplicationHelper
  # Appends the site title to the end of the page title.
  # The site title is defined in config/settings.yml.
  # @param page_title [String] the page title from a particular view.
  def title(page_title)
    site_title = SETTINGS[:site_title]
    if page_title.present?
      content_for :title, "#{page_title} | #{site_title}"
    else
      content_for :title, site_title
    end
  end

  # Since this app includes various parameters in the URL when linking to a
  # location's details page, we can end up with many URLs that display the
  # same content. To gain more control over which URL appears in Google search
  # results, we can use the <link> element with the 'rel=canonical' attribute.

  # This helper allows us to set the canonical URL for the details page in the
  # view. See app/views/organizations/show.html.haml
  #
  # More info: https://support.google.com/webmasters/answer/139066
  def canonical(url)
    content_for(:canonical, tag(:link, rel: :canonical, href: url)) if url
  end

  # List of Open Eligibility categories for when no search results are found.
  # @return [Array] Arrays of categories and sub-categories.
  # Only returns categories that have been associated with services since
  # it doesn't make sense to include categories that will return no locations.
  def taxonomy_terms
    { 'Emergency' =>
        ['Disaster Response', 'Emergency Cash', 'Cash for Food',
         'Cash for Healthcare', 'Cash for Housing', 'Cash for Gas',
         'Cash for Utilities', 'Emergency Food', 'Emergency Shelter',
         'Help Find Missing Persons', 'Immediate Safety',
         'Help Escape Violence', 'Safe Housing',
         'Psychiatric Emergency Services'
        ],
      'Food' =>
        ['Emergency Food', 'Food Delivery', 'Food Pantry', 'Free Meals',
         'Help Pay for Food', 'Food Benefits', 'Nutrition'
        ],
      'Housing' =>
        ['Emergency Shelter', 'Help Find Housing', 'Help Pay for Housing',
         'Cash for Housing', 'Cash for Utilities', 'Housing Vouchers',
         'Maintenance & Repairs', 'Housing Advice', 'Foreclosure Counseling',
         'Homebuyer Education', 'Residential Housing', 'Housing with Support',
         'Long-Term Housing', 'Assisted Living', 'Independent Living',
         'Nursing Home', 'Safe Housing', 'Short-Term Housing'
        ],
      'Goods' =>
        ['Baby Supplies', 'Baby Clothes', 'Clothing', 'Baby Clothes',
         'Clothes for School', 'Clothes for Work', 'Clothing Vouchers',
         'Home Goods', 'Blankets & Fans', 'Furniture', 'Personal Care Items',
         'Technology', 'Assistive Technology', 'Internet', 'Phone Services',
         'Toys & Gifts'
        ],
      'Transit' =>
        ['Help Pay for Transit', 'Bus Passes', 'Cash for Gas',
         'Transportation', 'Transportation for Healthcare',
         'Transportation for School'
        ],
      'Health' =>
        ['Addiction & Recovery', '12-Step', 'Detox', 'Halfway Housing',
         'Outpatient Treatment', 'Residential Treatment', 'Sober Living',
         'Dental Care', 'End-of-Life Care', 'Bereavement', 'Hospice',
         'Pain Management', 'Health Education', 'Daily Life Skills',
         'Disease Management', 'Family Planning', 'Nutrition',
         'Parenting Education', 'Sex Education', 'Understand Disability',
         'Understand Mental Health', 'Help Pay for Healthcare',
         'Cash for Healthcare', 'Discounted Healthcare', 'Health Insurance',
         'Medical Supplies', 'Prescription Assistance',
         'Transportation for Healthcare', 'Medical Care',
         'Alternative Medicine', 'Assistive Technology', 'Birth Control',
         'Checkup & Test', 'Disability Screening', 'Disease Screening',
         'Hearing Tests', 'Mental Health Evaluation', 'Pregnancy Tests',
         'Vision Tests', 'Maternity Care', 'Personal Hygiene',
         'Prevent & Treat', 'Counseling', 'HIV Treatment', 'Nursing Home',
         'Specialized Therapy', 'Vaccinations', 'Outpatient Treatment',
         'Psychiatric Emergency Services'
        ],
      'Money' =>
        ['Emergency Cash', 'Financial Assistance', 'Help Pay for Childcare',
         'Help Pay for Food', 'Help Pay for Housing', 'Help Pay for Transit',
         'Help Pay for Work Expenses', 'Government Benefits',
         'Disability Benefits', 'Food Benefits', 'Retirement Benefits',
         'Understand Government Programs', 'Vouchers', 'Clothing Vouchers',
         'Housing Vouchers', 'Financial Education', 'Foreclosure Counseling',
         'Savings Program', 'Insurance', 'Health Insurance',
         'Home & Renters Insurance', 'Tax Preparation'
        ],
      'Care' =>
        ['Adoption & Foster Care', 'Adoption & Foster Placement',
         'Adoption & Foster Parenting', 'Adoption Planning',
         'Post-Adoption Support', 'Animal Welfare', 'Daytime Care',
         'Adult Daycare', 'Afterschool Care', 'Childcare', 'Child Daycare',
         'Day Camp', 'Preschool', 'Recreation', 'Relief for Caregivers',
         'End-of-Life Care', 'Bereavement', 'Hospice', 'Pain Management',
         'Navigating the System', 'Help Fill out Forms', 'Help Find Housing',
         'Help Find Work', 'Residential Care', 'Assisted Living',
         'Residential Treatment', 'Nursing Home', 'Support Network',
         'Counseling', 'Help Hotlines', 'Home Visiting', 'In-Home Support',
         'Mentoring', 'One-on-One Support', 'Peer Support',
         'Spiritual Support', 'Support Groups', '12-Step',
         'Parenting Education', 'Virtual Support'
        ],
      'Education' =>
        ['Help Find School', 'Help Pay for School', 'Books',
         'Financial Aid & Loans', 'More Education', 'Alternative Education',
         'English as a Second Language (ESL)', 'Financial Education',
         'Foreign Languages', 'GED/High-School Equivalency',
         'Health Education', 'Supported Employment', 'Special Education',
         'Tutoring', 'Preschool', 'Screening & Exams', 'GED/High-School',
         'English as a Second Language (ESL)', 'Skills & Training',
         'Basic Literacy', 'Computer Class', 'Daily Life Skills',
         'Interview Training', 'Resume Development', 'Skills Assessment',
         'Specialized Training', 'Technology', 'Assistive Technology'
        ],
      'Work' =>
        ['Help Find Work', 'Job Placement', 'Supported Employment',
         'Help Pay for Work Expenses', 'Skills & Training', 'Basic Literacy',
         'Computer Class', 'GED/High-School Equivalency', 'Interview Training',
         'Resume Development', 'Skills Assessment', 'Specialized Training',
         'Supported Employment', 'Workplace Rights'
      ],
      'Legal' =>
        ['Advocacy & Legal Aid', 'Adoption & Foster Care',
         'Adoption & Foster Placement', 'Adoption Planning',
         'Post-Adoption Support', 'Citizenship & Immigration',
         'Discrimination & Civil Rights', 'Guardianship',
         'Understand Government Programs', 'Workplace Rights', 'Mediation',
         'Representation', 'Translation & Interpretation'
        ]
    }
  end
end
